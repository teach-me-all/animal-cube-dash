import SpriteKit

final class GhostRunPlayer {

    private let ghostData: GhostRunData
    private var currentFrameIndex: Int = 0
    private var startTime: TimeInterval = 0
    private var hasStarted = false

    private(set) var ghostNode: SKNode?
    private(set) var isFinished: Bool = false

    init(data: GhostRunData) {
        self.ghostData = data
    }

    func createGhostNode(skin: AnimalSkin) -> SKNode {
        let size = CGSize(width: 20, height: 20)
        let node = SKSpriteNode(color: .gray, size: size)
        node.alpha = 0.3
        node.zPosition = -1
        node.name = "ghostPlayer"

        // Add a subtle label with the skin emoji
        let label = SKLabelNode(text: skin.emoji)
        label.fontSize = 14
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.alpha = 0.5
        node.addChild(label)

        self.ghostNode = node
        return node
    }

    func update(currentTime: TimeInterval) {
        guard !isFinished, let node = ghostNode else { return }
        guard !ghostData.timestamps.isEmpty else {
            isFinished = true
            return
        }

        if !hasStarted {
            startTime = currentTime
            hasStarted = true
        }

        let elapsed = currentTime - startTime

        // Find the correct frame for the current elapsed time
        while currentFrameIndex < ghostData.timestamps.count - 1 &&
              ghostData.timestamps[currentFrameIndex + 1] <= elapsed {
            currentFrameIndex += 1
        }

        // Check if the ghost run is finished
        if currentFrameIndex >= ghostData.timestamps.count - 1 && elapsed >= ghostData.totalTime {
            isFinished = true
            node.alpha = 0.1
            return
        }

        // Interpolate position between current and next frame
        let currentPos = ghostData.positions[currentFrameIndex]
        let currentPoint = CGPoint(x: currentPos[0], y: currentPos[1])

        if currentFrameIndex < ghostData.timestamps.count - 1 {
            let nextPos = ghostData.positions[currentFrameIndex + 1]
            let nextPoint = CGPoint(x: nextPos[0], y: nextPos[1])

            let currentTimestamp = ghostData.timestamps[currentFrameIndex]
            let nextTimestamp = ghostData.timestamps[currentFrameIndex + 1]
            let frameDuration = nextTimestamp - currentTimestamp

            if frameDuration > 0 {
                let progress = (elapsed - currentTimestamp) / frameDuration
                let clampedProgress = max(0, min(1, progress))

                let interpolatedX = currentPoint.x + (nextPoint.x - currentPoint.x) * CGFloat(clampedProgress)
                let interpolatedY = currentPoint.y + (nextPoint.y - currentPoint.y) * CGFloat(clampedProgress)
                node.position = CGPoint(x: interpolatedX, y: interpolatedY)
            } else {
                node.position = currentPoint
            }
        } else {
            node.position = currentPoint
        }
    }

    func reset() {
        currentFrameIndex = 0
        startTime = 0
        hasStarted = false
        isFinished = false
        ghostNode?.alpha = 0.3
    }
}
