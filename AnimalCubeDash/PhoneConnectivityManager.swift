import Foundation
import WatchConnectivity

/// Manages WatchConnectivity on the iPhone side.
/// Receives progress updates and brag messages sent from the Watch.
final class PhoneConnectivityManager: NSObject, ObservableObject {
    static let shared = PhoneConnectivityManager()

    @Published var isWatchReachable = false
    @Published var lastReceivedBrag: String?

    private override init() {
        super.init()
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
}

extension PhoneConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        DispatchQueue.main.async {
            self.isWatchReachable = session.isReachable
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    // Receive synced progress context from Watch
    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String: Any]) {
        iOSProgressStore.shared.update(from: applicationContext)
    }

    // Receive real-time messages (e.g. brag) from Watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let brag = message["bragMessage"] as? String {
                self.lastReceivedBrag = brag
            }
        }
        iOSProgressStore.shared.update(from: message)
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchReachable = session.isReachable
        }
    }
}
