import Foundation
import WatchConnectivity

/// Manages WatchConnectivity on the Watch side.
/// Sends game progress and brag messages to the paired iPhone.
final class WatchConnectivityManager: NSObject {
    static let shared = WatchConnectivityManager()

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    /// Pushes the current progress snapshot to the iPhone via application context.
    /// Safe to call frequently; WatchConnectivity coalesces updates automatically.
    func syncProgress(_ store: GameProgressStore) {
        guard WCSession.default.activationState == .activated else { return }
        let context: [String: Any] = [
            "highestLevel": store.highestLevel,
            "currentLevel": store.currentLevel,
            "totalLevelsCompleted": store.totalLevelsCompleted,
            "unlockedSkins": store.unlockedSkins.map { $0.rawValue },
            "selectedSkin": store.selectedSkin.rawValue,
            "consecutivePerfectLevels": store.consecutivePerfectLevels
        ]
        try? WCSession.default.updateApplicationContext(context)
    }

    /// Sends a brag message directly to the iPhone if it's reachable.
    func sendBragToPhone(_ message: String) {
        guard WCSession.default.isReachable else { return }
        WCSession.default.sendMessage(["bragMessage": message], replyHandler: nil)
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
}
