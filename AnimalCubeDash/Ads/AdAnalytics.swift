enum AdAnalytics {
    // Replace body with: Analytics.logEvent(event, parameters: params)
    static func track(_ event: String, params: [String: Any] = [:]) {
        // print("[Ad] \(event) \(params)")
    }
}

// Event name constants
extension AdAnalytics {
    static let adImpression      = "ad_impression"
    static let rewardedStarted   = "rewarded_started"
    static let rewardedCompleted = "rewarded_completed"
    static let rewardedSkipped   = "rewarded_skipped"
    static let interstitialShown = "interstitial_shown"
}
