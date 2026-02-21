import SpriteKit

enum SpikeVariant: Int, Codable {
    case static_ = 0
    case popup = 1
    case rail = 2
}

final class SpikeNode: SKNode {
    let variant: SpikeVariant
    private var moveDirection: CGFloat = 1.0
    private var moveOrigin: CGPoint = .zero
    private var popupTimer: TimeInterval = 0
    private var isRetracted = false
    private var visualNode: SKNode!

    init(variant: SpikeVariant) {
        self.variant = variant
        super.init()
        name = "spike"
        setupVisual()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual() {
        visualNode = SpriteFactory.makeSpike(variant: variant)
        addChild(visualNode)
    }

    private func setupPhysics() {
        let size = CGSize(width: Constants.spikeWidth, height: Constants.spikeHeight)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.spike
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.none
        physicsBody = body
    }

    func setMoveOrigin(_ origin: CGPoint) {
        moveOrigin = origin
    }

    func update(deltaTime: TimeInterval) {
        switch variant {
        case .popup:
            updatePopup(deltaTime: deltaTime)
        case .rail:
            updateRail(deltaTime: deltaTime)
        case .static_:
            break
        }
    }

    private func updatePopup(deltaTime: TimeInterval) {
        popupTimer += deltaTime
        let cycle = popupTimer.truncatingRemainder(dividingBy: 3.0)

        if cycle < 1.5 && isRetracted {
            // Pop up
            isRetracted = false
            let popUp = SKAction.moveBy(x: 0, y: Constants.spikeHeight, duration: 0.15)
            visualNode.run(popUp)
            physicsBody?.categoryBitMask = PhysicsCategory.spike
        } else if cycle >= 1.5 && !isRetracted {
            // Retract
            isRetracted = true
            let retract = SKAction.moveBy(x: 0, y: -Constants.spikeHeight, duration: 0.15)
            visualNode.run(retract)
            physicsBody?.categoryBitMask = PhysicsCategory.none
        }
    }

    private func updateRail(deltaTime: TimeInterval) {
        let speed: CGFloat = 25.0
        let range: CGFloat = 30.0
        position.x += speed * moveDirection * CGFloat(deltaTime)
        if position.x > moveOrigin.x + range {
            moveDirection = -1
        } else if position.x < moveOrigin.x - range {
            moveDirection = 1
        }
    }

    func reset() {
        position = moveOrigin
        moveDirection = 1.0
        popupTimer = 0
        isRetracted = false
        visualNode.position = .zero
        physicsBody?.categoryBitMask = PhysicsCategory.spike
    }
}
