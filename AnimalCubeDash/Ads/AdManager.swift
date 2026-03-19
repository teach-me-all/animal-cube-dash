import Foundation
import UIKit
import GoogleMobileAds

private enum AdUnitID {
    static let interstitial = "ca-app-pub-9359627609474299/9090786568"
    static let rewarded      = "ca-app-pub-9359627609474299/1272973891"
}

@MainActor
class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()

    @Published var rewardedAdAvailable = false

    // Frequency tracking
    private(set) var levelsCompleted = 0
    private var lastPlayAdLevel  = -999
    private var lastEndAdLevel   = -999
    private var rewardedCountThisLevel = 0
    private var sessionStart = Date()

    private var interstitialAd: GADInterstitialAd?
    private var rewardedAd: GADRewardedAd?

    // Pending completion blocks used while an interstitial is on screen
    private var interstitialCompletion: (() -> Void)?
    // Strong reference so the weak delegate property doesn't drop it
    private var rewardedDismissDelegate: RewardedDismissDelegate?

    override private init() { super.init() }

    // MARK: - Configure (call once at app launch)

    func configure() {
        // COPPA: child-directed treatment — no personalised ads
        GADMobileAds.sharedInstance().requestConfiguration.tagForChildDirectedTreatment = true
        GADMobileAds.sharedInstance().start { [weak self] _ in
            Task { @MainActor in
                self?.preloadInterstitial()
                self?.preloadRewarded()
            }
        }
    }

    // MARK: - Level lifecycle

    func onLevelStarted(level: Int) {
        rewardedCountThisLevel = 0
    }

    func onLevelCompleted(level: Int) {
        levelsCompleted += 1
    }

    // MARK: - Frequency checks

    #if targetEnvironment(simulator)
    private let adsEnabled = false
    #else
    private let adsEnabled = true
    #endif

    func shouldShowPrePlayAd(level: Int) -> Bool {
        guard adsEnabled else { return false }
        let cfg = AdConfig.current
        guard sessionAge >= cfg.sessionMinSeconds else { return false }
        guard (level - lastPlayAdLevel) >= cfg.playAdInterval else { return false }
        guard (level - lastEndAdLevel) >= 1 else { return false }  // no back-to-back
        return interstitialAd != nil
    }

    func shouldShowPostLevelAd(level: Int) -> Bool {
        guard adsEnabled else { return false }
        let cfg = AdConfig.current
        guard sessionAge >= cfg.sessionMinSeconds else { return false }
        guard (level - lastEndAdLevel) >= cfg.endAdInterval else { return false }
        guard (level - lastPlayAdLevel) >= 1 else { return false }  // no back-to-back
        return interstitialAd != nil
    }

    func canShowRewardedAd(progress: Float) -> Bool {
        guard adsEnabled else { return false }
        guard AdConfig.current.nearWinEnabled else { return false }
        guard progress >= 0.4 else { return false }
        guard rewardedCountThisLevel < AdConfig.current.rewardedLimit else { return false }
        return rewardedAd != nil
    }

    // MARK: - Show methods

    func showPrePlayAd(level: Int, completion: @escaping () -> Void) {
        guard let ad = interstitialAd, let vc = topViewController() else {
            completion()
            return
        }
        lastPlayAdLevel = level
        interstitialCompletion = completion
        ad.fullScreenContentDelegate = self
        AdAnalytics.track(AdAnalytics.interstitialShown, params: ["placement": "pre_play", "level": level])
        ad.present(fromRootViewController: vc)
        interstitialAd = nil
        preloadInterstitial()
    }

    func showPostLevelAd(level: Int, completion: @escaping () -> Void) {
        guard let ad = interstitialAd, let vc = topViewController() else {
            completion()
            return
        }
        lastEndAdLevel = level
        interstitialCompletion = completion
        ad.fullScreenContentDelegate = self
        AdAnalytics.track(AdAnalytics.interstitialShown, params: ["placement": "post_level", "level": level])
        ad.present(fromRootViewController: vc)
        interstitialAd = nil
        preloadInterstitial()
    }

    func showRewardedAd(onReward: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        guard let ad = rewardedAd, let vc = topViewController() else {
            onDismiss()
            return
        }
        rewardedCountThisLevel += 1
        rewardedAd = nil
        rewardedAdAvailable = false
        AdAnalytics.track(AdAnalytics.rewardedStarted)
        // AdManager is a @MainActor singleton — no weak capture needed
        let dismissDelegate = RewardedDismissDelegate(onDismiss: {
            AdManager.shared.rewardedDismissDelegate = nil
            AdAnalytics.track(AdAnalytics.rewardedSkipped)
            onDismiss()
            Task { @MainActor in AdManager.shared.preloadRewarded() }
        })
        rewardedDismissDelegate = dismissDelegate
        ad.fullScreenContentDelegate = dismissDelegate
        ad.present(fromRootViewController: vc) {
            AdManager.shared.rewardedDismissDelegate = nil
            AdAnalytics.track(AdAnalytics.rewardedCompleted)
            onReward()
        }
        preloadRewarded()
    }

    // MARK: - Preload

    private func preloadInterstitial() {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AdUnitID.interstitial, request: req) { [weak self] ad, _ in
            Task { @MainActor in self?.interstitialAd = ad }
        }
    }

    private func preloadRewarded() {
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: AdUnitID.rewarded, request: req) { [weak self] ad, _ in
            Task { @MainActor in
                self?.rewardedAd = ad
                self?.rewardedAdAvailable = ad != nil
            }
        }
    }

    // MARK: - Helpers

    private var sessionAge: TimeInterval { Date().timeIntervalSince(sessionStart) }

    private func topViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else { return nil }
        var vc = window.rootViewController
        while let presented = vc?.presentedViewController { vc = presented }
        return vc
    }
}

// MARK: - Interstitial delegate

extension AdManager: @preconcurrency GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let completion = interstitialCompletion
        interstitialCompletion = nil
        completion?()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        let completion = interstitialCompletion
        interstitialCompletion = nil
        completion?()
    }
}

// MARK: - Rewarded dismiss delegate (separate object so we don't clobber the interstitial delegate)

@MainActor
private class RewardedDismissDelegate: NSObject, GADFullScreenContentDelegate {
    private let onDismiss: () -> Void
    init(onDismiss: @escaping () -> Void) { self.onDismiss = onDismiss }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) { onDismiss() }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) { onDismiss() }
}
