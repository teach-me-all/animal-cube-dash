import SpriteKit

final class PlayerCube: SKNode {
    let skin: AnimalSkin
    private(set) var isGrounded = false
    private(set) var isInQuicksand = false
    private(set) var isDucking = false
    private var lastSafePlatformPosition: CGPoint = .zero
    private var cubeVisual: SKNode!
    private var duckTimer: Timer?

    var lastSafePosition: CGPoint { lastSafePlatformPosition }

    init(skin: AnimalSkin) {
        self.skin = skin
        super.init()
        name = "player"
        setupVisual()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual() {
        cubeVisual = SpriteFactory.makePlayer(skin: skin)
        cubeVisual.name = "cubeVisual"
        addChild(cubeVisual)
    }

    private func setupPhysics() {
        let body = SKPhysicsBody(rectangleOf: Constants.playerSize)
        body.mass = Constants.playerMass
        body.allowsRotation = false
        body.restitution = 0.0
        body.friction = 0.4
        body.linearDamping = 0.0
        body.usesPreciseCollisionDetection = true
        body.categoryBitMask = PhysicsCategory.player
        body.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.hazards | PhysicsCategory.treasure | PhysicsCategory.boundary
        body.collisionBitMask = PhysicsCategory.platform
        physicsBody = body
    }

    func jump(isHighJump: Bool) {
        // Allow jump if grounded OR if resting on a surface (velocity nearly zero)
        let canJump = isGrounded || (abs(physicsBody?.velocity.dy ?? 999) < 5.0)
        guard canJump else { return }
        performJump(isHighJump: isHighJump)
    }

    /// Force a jump regardless of grounded state - used for direct tap input
    func forceJump(isHighJump: Bool) {
        performJump(isHighJump: isHighJump)
    }

    private func performJump(isHighJump: Bool) {
        let vel = isHighJump ? Constants.highJumpVelocity : Constants.jumpVelocity
        // Set velocity directly instead of impulse for reliable jump
        physicsBody?.velocity = CGVector(dx: 0, dy: vel)
        isGrounded = false

        // Squash-stretch: stretch on jump
        let stretch = SKAction.scaleY(to: 1.3, duration: 0.08)
        let restore = SKAction.scaleY(to: 1.0, duration: 0.12)
        cubeVisual.run(SKAction.sequence([stretch, restore]))

        CubeDrawing.setExpression(cubeVisual, expression: .happy)
        HapticManager.shared.playJump()
    }

    func land() {
        guard !isGrounded else { return }
        isGrounded = true

        // Squash on land
        let squash = SKAction.scaleY(to: 0.75, duration: 0.06)
        let restore = SKAction.scaleY(to: 1.0, duration: 0.1)
        cubeVisual.run(SKAction.sequence([squash, restore]))

        CubeDrawing.setExpression(cubeVisual, expression: .normal)
    }

    func markSafePosition() {
        lastSafePlatformPosition = position
    }

    func setGrounded(_ grounded: Bool) {
        isGrounded = grounded
    }

    func enterQuicksand() {
        isInQuicksand = true
        CubeDrawing.setExpression(cubeVisual, expression: .surprised)
    }

    func exitQuicksand() {
        isInQuicksand = false
        CubeDrawing.setExpression(cubeVisual, expression: .normal)
    }

    func playHitAnimation() {
        CubeDrawing.setExpression(cubeVisual, expression: .surprised)

        let blink = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        run(SKAction.repeat(blink, count: 3))
    }

    func playDeathAnimation(completion: @escaping () -> Void) {
        CubeDrawing.setExpression(cubeVisual, expression: .sad)

        let shrink = SKAction.scale(to: 0.1, duration: 0.3)
        let spin = SKAction.rotate(byAngle: .pi * 2, duration: 0.3)
        let fade = SKAction.fadeAlpha(to: 0, duration: 0.3)
        let group = SKAction.group([shrink, spin, fade])

        cubeVisual.run(group) {
            completion()
        }
    }

    func resetVisual() {
        if isDucking { standUp() }
        cubeVisual.alpha = 1.0
        cubeVisual.setScale(1.0)
        cubeVisual.zRotation = 0
        alpha = 1.0
        CubeDrawing.setExpression(cubeVisual, expression: .normal)
    }

    func duck() {
        guard !isDucking else { return }
        isDucking = true

        // Shrink physics body to half height so knives pass over
        let duckSize = CGSize(width: Constants.playerSize.width, height: Constants.playerSize.height * 0.5)
        let body = SKPhysicsBody(rectangleOf: duckSize)
        body.mass = Constants.playerMass
        body.allowsRotation = false
        body.restitution = 0.0
        body.friction = 0.4
        body.linearDamping = 0.0
        body.usesPreciseCollisionDetection = true
        body.categoryBitMask = PhysicsCategory.player
        body.contactTestBitMask = PhysicsCategory.platform | PhysicsCategory.hazards | PhysicsCategory.treasure | PhysicsCategory.boundary
        body.collisionBitMask = PhysicsCategory.platform
        body.velocity = physicsBody?.velocity ?? .zero
        physicsBody = body

        // Squash visual to look like ducking
        let squash = SKAction.scaleY(to: 0.5, duration: 0.08)
        cubeVisual.run(squash, withKey: "duck")

        CubeDrawing.setExpression(cubeVisual, expression: .surprised)
        HapticManager.shared.playJump()

        // Auto stand up after 0.8 seconds
        duckTimer?.invalidate()
        duckTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
            self?.standUp()
        }
    }

    func standUp() {
        guard isDucking else { return }
        isDucking = false
        duckTimer?.invalidate()
        duckTimer = nil

        // Restore full physics body
        setupPhysics()

        // Restore visual
        let restore = SKAction.scaleY(to: 1.0, duration: 0.1)
        cubeVisual.run(restore, withKey: "duck")

        CubeDrawing.setExpression(cubeVisual, expression: .normal)
    }

    func changeSkin(to newSkin: AnimalSkin) {
        cubeVisual.removeFromParent()
        cubeVisual = SpriteFactory.makePlayer(skin: newSkin)
        cubeVisual.name = "cubeVisual"
        addChild(cubeVisual)
    }
}
