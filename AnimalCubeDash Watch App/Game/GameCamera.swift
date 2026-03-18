import SpriteKit

final class GameCamera: SKCameraNode {
    private var targetX: CGFloat = 0

    func update(scrollPosition: CGFloat) {
        targetX = scrollPosition + Constants.cameraLeadX
        let newX = position.x + (targetX - position.x) * 0.1
        position.x = newX
    }

    func jumpTo(x: CGFloat) {
        position.x = x + Constants.cameraLeadX
        targetX = position.x
    }

    func reset() {
        #if os(iOS)
        // Center viewport on gameplay area (ground y≈60, max jump y≈200, midpoint ≈ 120)
        position = CGPoint(x: Constants.sceneSize.width / 2, y: 120)
        #else
        position = CGPoint(x: Constants.sceneSize.width / 2, y: Constants.sceneSize.height / 2)
        #endif
        targetX = position.x
    }
}
