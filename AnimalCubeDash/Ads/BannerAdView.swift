import SwiftUI
import UIKit
import GoogleMobileAds

private let bannerAdUnitID = "ca-app-pub-9359627609474299/6165240322"

struct BannerAdView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> GADBannerView {
        let adSize = GADAdSizeFullWidthPortraitWithHeight(50)
        let banner = GADBannerView(adSize: adSize)
        banner.adUnitID = bannerAdUnitID
        banner.delegate = context.coordinator
        context.coordinator.banner = banner
        // rootViewController set in updateUIView once the view is in the hierarchy
        return banner
    }

    func updateUIView(_ banner: GADBannerView, context: Context) {
        if banner.rootViewController == nil {
            banner.rootViewController = topViewController()
        }
        if !context.coordinator.hasLoaded {
            context.coordinator.hasLoaded = true
            banner.load(GADRequest())
        }
    }

    private func topViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else { return nil }
        var vc = window.rootViewController
        while let presented = vc?.presentedViewController { vc = presented }
        return vc
    }

    // MARK: - Coordinator

    class Coordinator: NSObject, GADBannerViewDelegate {
        weak var banner: GADBannerView?
        var hasLoaded = false

        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            AdAnalytics.track(AdAnalytics.adImpression, params: ["placement": "banner"])
        }
    }
}

/// Fixed-height container: full screen width, 50pt tall. Hidden on simulator.
struct BannerAdContainer: View {
    var body: some View {
        #if targetEnvironment(simulator)
        EmptyView()
        #else
        BannerAdView()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
        #endif
    }
}
