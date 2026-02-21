import SpriteKit

extension GameScene {
    // MARK: - Tap Handling
    // On watchOS, taps are forwarded from SwiftUI gesture recognizers.
    // Single tap = jump immediately. Double tap within window = high jump.

    private static var lastTapTime: TimeInterval = 0

    func handleTap() {
        // Allow tap during playing state; also allow during respawn for responsiveness
        guard stateMachine.currentStateType == .playing else { return }

        let now = Date().timeIntervalSinceReferenceDate
        let elapsed = now - GameScene.lastTapTime
        GameScene.lastTapTime = now

        let isHighJump = elapsed < Constants.doubleTapWindow

        // Force jump - bypass grounded checks to ensure tap always responds
        player.forceJump(isHighJump: isHighJump)
    }

    // MARK: - Swipe Down (Duck)

    func handleSwipeDown() {
        guard stateMachine.currentStateType == .playing else { return }
        player.duck()
    }
}
