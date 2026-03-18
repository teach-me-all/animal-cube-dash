import Foundation

struct AdConfig {
    var playAdInterval: Int = 4          // interstitial every N levels pre-play
    var endAdInterval: Int = 3           // interstitial every N levels post-level
    var rewardedLimit: Int = 2           // max rewarded ads per level
    var nearWinEnabled: Bool = true      // rewarded only if progress >= 40%
    var adCooldownSeconds: TimeInterval = 30
    var sessionMinSeconds: TimeInterval = 120  // no ads in first 2 min of session

    // Replace with Firebase RemoteConfig fetch later
    static var current = AdConfig()
}
