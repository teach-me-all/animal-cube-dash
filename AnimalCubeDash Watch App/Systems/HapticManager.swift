import WatchKit

final class HapticManager {
    static let shared = HapticManager()
    private init() {}

    func playJump() {
        WKInterfaceDevice.current().play(.click)
    }

    func playLand() {
        WKInterfaceDevice.current().play(.click)
    }

    func playHit() {
        WKInterfaceDevice.current().play(.failure)
    }

    func playDeath() {
        WKInterfaceDevice.current().play(.failure)
    }

    func playLevelComplete() {
        WKInterfaceDevice.current().play(.success)
    }

    func playSkinUnlock() {
        WKInterfaceDevice.current().play(.success)
    }

    func playNearMiss() {
        WKInterfaceDevice.current().play(.directionUp)
    }
}
