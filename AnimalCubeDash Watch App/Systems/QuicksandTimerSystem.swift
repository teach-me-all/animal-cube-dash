import SpriteKit

final class QuicksandTimerSystem {
    private(set) var isActive = false
    private(set) var timeRemaining: TimeInterval = Constants.quicksandTimer
    private var timerRing: SKShapeNode?
    private weak var player: PlayerCube?

    var onTimerExpired: (() -> Void)?

    func startTimer(for player: PlayerCube) {
        guard !isActive else { return }
        self.player = player
        isActive = true
        timeRemaining = Constants.quicksandTimer
        createTimerRing()
    }

    func stopTimer() {
        isActive = false
        timeRemaining = Constants.quicksandTimer
        removeTimerRing()
        player?.exitQuicksand()
    }

    func update(deltaTime: TimeInterval) {
        guard isActive else { return }

        timeRemaining -= deltaTime

        if timeRemaining <= 0 {
            isActive = false
            removeTimerRing()
            onTimerExpired?()
            return
        }

        updateTimerRing()

        // Sink the player
        if let player = player {
            player.position.y -= Constants.quicksandSinkRate * CGFloat(deltaTime)
        }
    }

    private func createTimerRing() {
        guard let player = player else { return }
        removeTimerRing()

        let ring = ObstacleDrawing.createTimerRing(radius: 12)
        ring.name = "quicksandTimerRing"
        ring.zPosition = 100
        player.addChild(ring)
        timerRing = ring
    }

    private func removeTimerRing() {
        timerRing?.removeFromParent()
        timerRing = nil
    }

    private func updateTimerRing() {
        guard let ring = timerRing else { return }

        let fraction = CGFloat(timeRemaining / Constants.quicksandTimer)

        // Update color: green -> yellow -> red
        let color: SKColor
        if fraction > 0.6 {
            color = .green
        } else if fraction > 0.3 {
            color = .yellow
        } else {
            color = .red
        }

        // Redraw ring arc
        let endAngle = CGFloat.pi / 2.0 + (1.0 - fraction) * CGFloat.pi * 2.0
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: 12, startAngle: .pi / 2, endAngle: endAngle, clockwise: true)
        ring.path = path
        ring.strokeColor = color
        ring.lineWidth = 2
    }

    func reset() {
        stopTimer()
    }
}
