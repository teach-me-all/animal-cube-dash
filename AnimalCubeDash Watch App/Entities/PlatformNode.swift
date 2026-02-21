import SpriteKit

enum PlatformType: Int, Codable {
    case static_ = 0
    case movingH = 1
    case movingV = 2
    case timed = 3
}

final class PlatformNode: SKNode {
    let platformType: PlatformType
    let platformWidth: CGFloat
    private var moveDirection: CGFloat = 1.0
    private var moveOrigin: CGPoint = .zero
    private var isVisible = true
    private var timerAccumulator: TimeInterval = 0
    private var visualNode: SKNode!

    init(type: PlatformType, width: CGFloat) {
        self.platformType = type
        self.platformWidth = width
        super.init()
        name = "platform"
        setupVisual(width: width)
        setupPhysics(width: width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual(width: CGFloat) {
        visualNode = SpriteFactory.makePlatform(width: width, type: platformType)
        addChild(visualNode)
    }

    private func setupPhysics(width: CGFloat) {
        let size = CGSize(width: width, height: Constants.platformHeight)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.platform
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.player
        body.friction = 0.6
        physicsBody = body
    }

    func setMoveOrigin(_ origin: CGPoint) {
        moveOrigin = origin
    }

    func update(deltaTime: TimeInterval) {
        switch platformType {
        case .movingH:
            updateMovingH(deltaTime: deltaTime)
        case .movingV:
            updateMovingV(deltaTime: deltaTime)
        case .timed:
            updateTimed(deltaTime: deltaTime)
        case .static_:
            break
        }
    }

    private func updateMovingH(deltaTime: TimeInterval) {
        let speed = Constants.movingPlatformSpeed
        let range = Constants.movingPlatformRange
        position.x += speed * moveDirection * CGFloat(deltaTime)
        if position.x > moveOrigin.x + range {
            moveDirection = -1
        } else if position.x < moveOrigin.x - range {
            moveDirection = 1
        }
    }

    private func updateMovingV(deltaTime: TimeInterval) {
        let speed = Constants.movingPlatformSpeed * 0.7
        let range = Constants.movingPlatformRange * 0.5
        position.y += speed * moveDirection * CGFloat(deltaTime)
        if position.y > moveOrigin.y + range {
            moveDirection = -1
        } else if position.y < moveOrigin.y - range {
            moveDirection = 1
        }
    }

    private func updateTimed(deltaTime: TimeInterval) {
        timerAccumulator += deltaTime
        let cycleDuration = Constants.timedPlatformOnDuration + Constants.timedPlatformOffDuration

        let cycleTime = timerAccumulator.truncatingRemainder(dividingBy: cycleDuration)
        let shouldBeVisible = cycleTime < Constants.timedPlatformOnDuration

        if shouldBeVisible != isVisible {
            isVisible = shouldBeVisible
            visualNode.alpha = isVisible ? 1.0 : 0.3
            physicsBody?.categoryBitMask = isVisible ? PhysicsCategory.platform : PhysicsCategory.none
            physicsBody?.collisionBitMask = isVisible ? PhysicsCategory.player : PhysicsCategory.none
        }

        // Blink warning before disappearing
        if isVisible {
            let timeLeft = Constants.timedPlatformOnDuration - cycleTime
            if timeLeft < 0.5 {
                let blinkRate = sin(timeLeft * 20) > 0
                visualNode.alpha = blinkRate ? 1.0 : 0.5
            }
        }
    }

    func reset() {
        position = moveOrigin
        moveDirection = 1.0
        timerAccumulator = 0
        isVisible = true
        visualNode.alpha = 1.0
        physicsBody?.categoryBitMask = PhysicsCategory.platform
        physicsBody?.collisionBitMask = PhysicsCategory.player
    }
}
