import Foundation
#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

final class HapticManager {
    static let shared = HapticManager()
    private init() {}

    func playJump() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.click)
        #else
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    func playLand() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.click)
        #else
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }

    func playHit() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.failure)
        #else
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }

    func playDeath() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.failure)
        #else
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }

    func playLevelComplete() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #else
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    func playSkinUnlock() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.success)
        #else
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }

    func playNearMiss() {
        #if os(watchOS)
        WKInterfaceDevice.current().play(.directionUp)
        #else
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        #endif
    }
}
