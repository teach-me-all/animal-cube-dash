import SpriteKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        hypot(x - point.x, y - point.y)
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

extension SKNode {
    var positionInScene: CGPoint {
        guard let scene = scene else { return position }
        guard let parent = parent else { return position }
        return scene.convert(position, from: parent)
    }

    func isOnScreen(camera: SKCameraNode?, sceneSize: CGSize) -> Bool {
        guard let camera = camera else { return true }
        let camPos = camera.position
        let halfW = sceneSize.width / 2 + 40
        let halfH = sceneSize.height / 2 + 40
        let pos = position
        // Only cull nodes that have scrolled off the LEFT side of the screen.
        // Nodes ahead (to the right) should never be culled even if far away,
        // because they were pre-spawned and the camera hasn't reached them yet.
        return pos.x > camPos.x - halfW
            && pos.y > camPos.y - halfH && pos.y < camPos.y + halfH
    }
}

extension SKShapeNode {
    static func roundedRect(size: CGSize, cornerRadius: CGFloat, color: SKColor) -> SKShapeNode {
        let path = CGPath(roundedRect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2),
                                               size: size),
                          cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        let node = SKShapeNode(path: path)
        node.fillColor = color
        node.strokeColor = color.withAlphaComponent(0.8)
        node.lineWidth = 0.5
        return node
    }
}

extension SKColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
