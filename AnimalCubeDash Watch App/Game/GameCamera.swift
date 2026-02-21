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
        position = CGPoint(x: Constants.sceneSize.width / 2, y: Constants.sceneSize.height / 2)
        targetX = position.x
    }
}
