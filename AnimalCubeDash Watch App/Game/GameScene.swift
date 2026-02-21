import SpriteKit

class GameScene: SKScene {
    // MARK: - Properties
    private(set) var player: PlayerCube!
    var gameCamera: GameCamera!
    var stateMachine: GameStateMachine!
    private var scrollController: ScrollController!
    private var nodePool: NodePool!
    private var levelGenerator: LevelGenerator!
    var quicksandTimer: QuicksandTimerSystem!

    private var currentLevel: Int = 1
    private var currentSkin: AnimalSkin = .cat
    private(set) var livesRemaining: Int = Constants.maxLives
    private var lastUpdateTime: TimeInterval = 0
    private var isGameActive = false
    var lastHitKnifeX: CGFloat?

    // HUD nodes
    private var hudNode: SKNode!
    private var heartNodes: [SKNode] = []
    private var progressBar: SKShapeNode!
    private var progressFill: SKShapeNode!

    // Parallax
    private var cloudLayer: SKNode!

    // Callbacks for SwiftUI
    var onStateChange: ((GameStateType) -> Void)?
    var onLivesChange: ((Int) -> Void)?
    var onLevelComplete: ((Int) -> Void)?
    var onGameOver: (() -> Void)?

    // MARK: - Scene Lifecycle

    override func sceneDidLoad() {
        super.sceneDidLoad()
        backgroundColor = SKColor(hex: 0x87CEEB) // sky blue
        physicsWorld.gravity = CGVector(dx: 0, dy: Constants.gravity)
        physicsWorld.contactDelegate = self

        setupCamera()
        setupBackground()
        setupHUD()
        setupSystems()
    }

    func configure(level: Int, skin: AnimalSkin) {
        currentLevel = level
        currentSkin = skin
    }

    func startGame() {
        resetLevel()
        lastUpdateTime = 0
        stateMachine.enter(.playing)
        isGameActive = true

        // After a short delay, check if player is resting on a platform and set grounded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }
            if let vy = self.player.physicsBody?.velocity.dy, abs(vy) < 2.0 {
                self.player.setGrounded(true)
            }
        }
    }

    // MARK: - Setup

    private func setupCamera() {
        gameCamera = GameCamera()
        gameCamera.reset()
        camera = gameCamera
        addChild(gameCamera)
    }

    private func setupBackground() {
        // Attach sky to camera so it always fills the screen
        let bg = EnvironmentDrawing.createSkyBackground(size: CGSize(width: Constants.sceneSize.width + 20, height: Constants.sceneSize.height + 20))
        bg.zPosition = -100
        gameCamera.addChild(bg)

        cloudLayer = EnvironmentDrawing.createParallaxLayer(sceneSize: Constants.sceneSize)
        cloudLayer.zPosition = -50
        addChild(cloudLayer)
    }

    private func setupHUD() {
        hudNode = SKNode()
        hudNode.zPosition = 200
        gameCamera.addChild(hudNode)

        // Hearts
        updateHeartsDisplay()

        // Progress bar
        let barBg = SKShapeNode(rectOf: CGSize(width: Constants.progressBarWidth, height: Constants.progressBarHeight), cornerRadius: 1.5)
        barBg.fillColor = SKColor.white.withAlphaComponent(0.3)
        barBg.strokeColor = .clear
        barBg.position = CGPoint(x: 0, y: Constants.sceneSize.height / 2 - Constants.hudTopMargin - 20)
        hudNode.addChild(barBg)

        progressFill = SKShapeNode(rectOf: CGSize(width: 1, height: Constants.progressBarHeight), cornerRadius: 1.5)
        progressFill.fillColor = .green
        progressFill.strokeColor = .clear
        progressFill.position = barBg.position
        progressFill.xScale = 0.01
        hudNode.addChild(progressFill)
    }

    private func updateHeartsDisplay() {
        heartNodes.forEach { $0.removeFromParent() }
        heartNodes.removeAll()

        let startX = -Constants.sceneSize.width / 2 + 15
        let y = Constants.sceneSize.height / 2 - Constants.hudTopMargin - 6

        for i in 0..<Constants.maxLives {
            let filled = i < livesRemaining
            let heart = SpriteFactory.makeHeart(filled: filled)
            heart.position = CGPoint(x: startX + CGFloat(i) * (Constants.heartSize + Constants.heartSpacing), y: y)
            hudNode.addChild(heart)
            heartNodes.append(heart)
        }
    }

    private func setupSystems() {
        nodePool = NodePool()
        scrollController = ScrollController()
        quicksandTimer = QuicksandTimerSystem()
        quicksandTimer.onTimerExpired = { [weak self] in
            self?.loseLife()
        }
        stateMachine = GameStateMachine(scene: self)
    }

    // MARK: - Level Management

    private func resetLevel() {
        // Remove old nodes
        nodePool.deactivateAll()
        children.filter { $0.name == "treasure" }.forEach { $0.removeFromParent() }

        // Reset systems
        scrollController.reset()
        quicksandTimer.reset()
        levelGenerator = LevelGenerator(nodePool: nodePool, level: currentLevel)

        // Reset player
        if player != nil {
            player.removeFromParent()
        }
        player = PlayerCube(skin: currentSkin)
        player.position = CGPoint(x: Constants.playerStartX, y: Constants.playerGroundY + 20)
        player.zPosition = 50
        addChild(player)

        // Reset lives
        livesRemaining = Constants.maxLives
        updateHeartsDisplay()
        onLivesChange?(livesRemaining)

        // Reset camera
        gameCamera.reset()

        // Remove old bottom boundaries before adding a new one
        children.filter { $0.name == "bottomBoundary" }.forEach { $0.removeFromParent() }

        // Add bottom boundary
        setupBoundary()

        // Immediately spawn the first segments so platforms exist before the player falls
        levelGenerator.spawnIfNeeded(
            cameraX: gameCamera.position.x,
            sceneWidth: Constants.sceneSize.width,
            parent: self
        )
    }

    private func setupBoundary() {
        // Bottom kill zone
        let boundary = SKNode()
        boundary.name = "bottomBoundary"
        boundary.position = CGPoint(x: 2000, y: -20)
        let body = SKPhysicsBody(rectangleOf: CGSize(width: 8000, height: 10))
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.boundary
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.none
        boundary.physicsBody = body
        addChild(boundary)
    }

    // MARK: - Update Loop

    override func update(_ currentTime: TimeInterval) {
        guard isGameActive else { return }
        guard stateMachine.currentStateType == .playing else { return }

        let deltaTime: TimeInterval
        if lastUpdateTime == 0 {
            deltaTime = 1.0 / 30.0
        } else {
            deltaTime = min(currentTime - lastUpdateTime, 1.0 / 15.0) // cap delta
        }
        lastUpdateTime = currentTime

        // Scroll
        scrollController.update(deltaTime: deltaTime)

        // Move camera
        gameCamera.update(scrollPosition: scrollController.scrollPosition)

        // Push player with scroll
        player.position.x = scrollController.scrollPosition + Constants.playerStartX

        // Update parallax clouds
        cloudLayer.position.x = gameCamera.position.x * 0.3

        // Spawn new segments
        levelGenerator.spawnIfNeeded(
            cameraX: gameCamera.position.x,
            sceneWidth: Constants.sceneSize.width,
            parent: self
        )

        // Spawn treasure
        _ = levelGenerator.spawnTreasureIfNeeded(
            cameraX: gameCamera.position.x,
            sceneWidth: Constants.sceneSize.width,
            parent: self
        )

        // Update active nodes
        for node in nodePool.activeNodes {
            if let platform = node as? PlatformNode {
                platform.update(deltaTime: deltaTime)
            } else if let spike = node as? SpikeNode {
                spike.update(deltaTime: deltaTime)
            } else if let knife = node as? FlyingKnifeNode {
                knife.update(deltaTime: deltaTime)
            }
        }

        // Quicksand timer
        quicksandTimer.update(deltaTime: deltaTime)

        // Cull offscreen nodes
        nodePool.cullOffscreen(camera: gameCamera, sceneSize: Constants.sceneSize)

        // Update progress bar
        let progress = scrollController.progress
        progressFill.xScale = max(0.01, min(1.0, progress)) * Constants.progressBarWidth

        // Check if player passed the treasure chest (level complete)
        let treasureX = Constants.levelLength - 50
        if player.position.x > treasureX + 20 {
            if let treasure = children.first(where: { $0.name == "treasure" }) as? TreasureChestNode {
                treasure.playOpenAnimation { [weak self] in
                    self?.stateMachine.enter(.levelComplete)
                }
            } else {
                stateMachine.enter(.levelComplete)
            }
            return
        }

        // Check if player fell below the visible area
        if player.position.y < -10 {
            // Try to rescue onto the next platform ahead instead of losing a life
            if let nextPlatform = findNextPlatformAhead(from: player.position.x) {
                rescueOnto(platform: nextPlatform)
            } else {
                loseLife()
            }
        }
    }

    // MARK: - Life System

    func loseLife() {
        guard stateMachine.currentStateType == .playing else { return }

        livesRemaining -= 1
        updateHeartsDisplay()
        onLivesChange?(livesRemaining)
        HapticManager.shared.playHit()

        if livesRemaining <= 0 {
            stateMachine.enter(.gameOver)
        } else {
            stateMachine.enter(.respawn)
        }
    }

    func respawnPlayer() {
        quicksandTimer.stopTimer()

        // Find the nearest platform that still exists to respawn on
        // If hit by a knife, respawn on the next platform ahead of the knife
        let currentScrollX = scrollController.scrollPosition
        let respawnY: CGFloat

        let respawnScrollX: CGFloat

        let targetPlatform: PlatformNode?
        if let knifeX = lastHitKnifeX {
            // Find the first platform strictly ahead of the knife
            targetPlatform = findFirstPlatformAfter(x: knifeX)
            lastHitKnifeX = nil
        } else {
            targetPlatform = findNearestPlatform(to: currentScrollX + Constants.playerStartX)
        }

        if let platform = targetPlatform {
            respawnY = platform.position.y + Constants.platformHeight / 2 + Constants.playerSize.height / 2 + 2
            respawnScrollX = platform.position.x - Constants.playerStartX
        } else {
            // Fallback: stay at current scroll, use default ground Y
            respawnY = Constants.playerGroundY + 20
            respawnScrollX = currentScrollX
        }

        // Set scroll position so the player lines up with the platform
        scrollController = ScrollController(baseSpeed: Constants.baseScrollSpeed)
        scrollController.setScrollPosition(respawnScrollX)
        lastUpdateTime = 0

        // Place player at the platform position and freeze physics during respawn delay
        player.position = CGPoint(x: respawnScrollX + Constants.playerStartX, y: respawnY)
        player.physicsBody?.velocity = .zero
        player.physicsBody?.isDynamic = false  // freeze so gravity doesn't pull player off
        player.resetVisual()
        player.setGrounded(true)

        gameCamera.jumpTo(x: respawnScrollX)

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.respawnDelay) { [weak self] in
            guard let self = self else { return }
            self.player.physicsBody?.isDynamic = true  // unfreeze physics
            self.player.physicsBody?.velocity = .zero
            self.stateMachine.enter(.playing)
        }
    }

    /// Find the nearest active platform to the given X position
    private func findNearestPlatform(to targetX: CGFloat) -> PlatformNode? {
        let platforms = nodePool.activeNodes.compactMap { $0 as? PlatformNode }
        // Prefer platforms at or ahead of the target, but accept any nearby platform
        return platforms.min(by: { abs($0.position.x - targetX) < abs($1.position.x - targetX) })
    }

    /// Find the next platform ahead of the player's X position
    private func findNextPlatformAhead(from playerX: CGFloat) -> PlatformNode? {
        let platforms = nodePool.activeNodes.compactMap { $0 as? PlatformNode }
        let ahead = platforms.filter { $0.position.x > playerX - 20 }
        return ahead.min(by: { $0.position.x < $1.position.x })
    }

    /// Find the first platform strictly ahead of the given X position (past a knife)
    private func findFirstPlatformAfter(x: CGFloat) -> PlatformNode? {
        let platforms = nodePool.activeNodes.compactMap { $0 as? PlatformNode }
        let ahead = platforms.filter { $0.position.x > x + 10 }
        return ahead.min(by: { $0.position.x < $1.position.x })
    }

    /// Rescue the player onto a platform without losing a life
    private func rescueOnto(platform: PlatformNode) {
        guard stateMachine.currentStateType == .playing else { return }
        stateMachine.enter(.respawn)

        let rescueY = platform.position.y + Constants.platformHeight / 2 + Constants.playerSize.height / 2 + 2
        player.position = CGPoint(x: platform.position.x, y: rescueY)
        player.physicsBody?.velocity = .zero
        player.physicsBody?.isDynamic = false
        player.setGrounded(true)
        player.resetVisual()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.player.physicsBody?.isDynamic = true
            self.player.physicsBody?.velocity = .zero
            self.stateMachine.enter(.playing)
        }
    }

    // MARK: - Digital Crown

    func updateCrownValue(_ value: Double) {
        scrollController.updateCrown(value: value)
    }

    // MARK: - Pause

    func togglePause() {
        if stateMachine.currentStateType == .playing {
            stateMachine.enter(.paused)
            isGameActive = false
        } else if stateMachine.currentStateType == .paused {
            stateMachine.enter(.playing)
            isGameActive = true
            lastUpdateTime = 0 // reset delta calculation
        }
    }

    func resumeGame() {
        if stateMachine.currentStateType == .paused {
            stateMachine.enter(.playing)
            isGameActive = true
            lastUpdateTime = 0
        }
    }

    // MARK: - Level Complete

    private func handleLevelComplete() {
        isGameActive = false
        PlayerAnimationHelper.confettiEffect(at: player.position, in: self)
        HapticManager.shared.playLevelComplete()
        onLevelComplete?(currentLevel)
    }

    func restartLevel() {
        startGame()
    }

    func nextLevel() {
        currentLevel += 1
        startGame()
    }
}

// MARK: - GameStateDelegate

extension GameScene: GameStateDelegate {
    func stateDidChange(to state: GameStateType) {
        onStateChange?(state)
    }

    func requestRespawn() {
        player.playHitAnimation()
        PlayerAnimationHelper.deathPoof(at: player.position, in: self)
        respawnPlayer()
    }

    func requestLevelComplete() {
        handleLevelComplete()
    }

    func requestGameOver() {
        isGameActive = false
        HapticManager.shared.playDeath()
        onGameOver?()
    }

    func requestRestart() {
        startGame()
    }
}
