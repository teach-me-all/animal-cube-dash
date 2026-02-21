import SpriteKit

final class FlyingKnifeNode: SKNode {
    private var moveDirection: CGVector
    private var visualNode: SKNode!
    private var warningGlow: SKShapeNode?
    private var hasEnteredScreen = false

    init(direction: CGVector = CGVector(dx: -1, dy: 0)) {
        self.moveDirection = direction
        super.init()
        name = "knife"
        setupVisual()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual() {
        visualNode = SpriteFactory.makeKnife()
        addChild(visualNode)

        // Continuous spin
        let spin = SKAction.rotate(byAngle: -.pi * 2, duration: 0.5)
        visualNode.run(SKAction.repeatForever(spin))
    }

    private func setupPhysics() {
        let size = CGSize(width: Constants.knifeSize, height: Constants.knifeSize)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.knife
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.none
        physicsBody = body
    }

    func showWarning() {
        warningGlow = ObstacleDrawing.createWarningGlow()
        if let glow = warningGlow {
            glow.position = CGPoint(x: Constants.knifeSize, y: 0)
            addChild(glow)

            let pulse = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: 0.3),
                SKAction.fadeAlpha(to: 1.0, duration: 0.3)
            ])
            glow.run(SKAction.repeat(pulse, count: 3)) { [weak self] in
                self?.warningGlow?.removeFromParent()
                self?.warningGlow = nil
            }
        }
    }

    func update(deltaTime: TimeInterval) {
        let speed = Constants.knifeSpeed * CGFloat(deltaTime)
        position.x += moveDirection.dx * speed
        position.y += moveDirection.dy * speed
    }
}
