import SpriteKit

final class TreasureChestNode: SKNode {
    private var visualNode: SKNode!
    private var isOpened = false

    override init() {
        super.init()
        name = "treasure"
        setupVisual()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual() {
        visualNode = SpriteFactory.makeTreasureChest()
        addChild(visualNode)

        // Gentle bob animation
        let bob = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 2, duration: 0.8),
            SKAction.moveBy(x: 0, y: -2, duration: 0.8)
        ])
        visualNode.run(SKAction.repeatForever(bob))

        // Sparkle effect
        addSparkles()
    }

    private func setupPhysics() {
        let body = SKPhysicsBody(rectangleOf: Constants.treasureSize)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.treasure
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.none
        physicsBody = body
    }

    private func addSparkles() {
        let sparkle = SKAction.sequence([
            SKAction.wait(forDuration: 1.0, withRange: 0.5),
            SKAction.run { [weak self] in
                self?.emitSparkle()
            }
        ])
        run(SKAction.repeatForever(sparkle))
    }

    private func emitSparkle() {
        let star = SKShapeNode(circleOfRadius: 1.5)
        star.fillColor = .yellow
        star.strokeColor = .clear
        star.position = CGPoint(
            x: CGFloat.random(in: -10...10),
            y: CGFloat.random(in: -5...10)
        )
        addChild(star)

        let rise = SKAction.moveBy(x: 0, y: 8, duration: 0.6)
        let fade = SKAction.fadeOut(withDuration: 0.6)
        let group = SKAction.group([rise, fade])
        star.run(SKAction.sequence([group, SKAction.removeFromParent()]))
    }

    func playOpenAnimation(completion: @escaping () -> Void) {
        guard !isOpened else { return }
        isOpened = true
        removeAllActions()

        // Lid opens
        let jump = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 8, duration: 0.2),
            SKAction.moveBy(x: 0, y: -4, duration: 0.15)
        ])
        let scale = SKAction.scale(to: 1.3, duration: 0.2)
        visualNode.run(SKAction.group([jump, scale])) {
            completion()
        }

        HapticManager.shared.playLevelComplete()
    }
}
