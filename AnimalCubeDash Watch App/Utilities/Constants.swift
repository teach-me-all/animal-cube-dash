import SpriteKit

enum Constants {
    // MARK: - Screen
    #if os(watchOS)
    static let sceneSize = CGSize(width: 184, height: 224)
    static let sceneScale: CGFloat = 1.0

    // MARK: - Physics
    static let gravity: CGFloat = -9.0
    static let jumpVelocity: CGFloat = 500.0
    static let highJumpVelocity: CGFloat = 700.0
    static let playerMass: CGFloat = 0.3

    // MARK: - Player
    static let playerSize = CGSize(width: 16, height: 16)
    static let playerCornerRadius: CGFloat = 3.0
    static let playerStartX: CGFloat = 40
    static let playerGroundY: CGFloat = 40

    // MARK: - Scrolling
    static let baseScrollSpeed: CGFloat = 60.0 // points per second
    static let levelLength: CGFloat = 3600.0 // ~60s at base speed

    // MARK: - Platform
    static let platformHeight: CGFloat = 8
    static let platformMinWidth: CGFloat = 24
    static let platformMaxWidth: CGFloat = 48
    static let movingPlatformSpeed: CGFloat = 30.0
    static let movingPlatformRange: CGFloat = 40.0

    // MARK: - Obstacles
    static let spikeWidth: CGFloat = 12
    static let spikeHeight: CGFloat = 14
    static let knifeSize: CGFloat = 14
    static let knifeSpeed: CGFloat = 50.0
    static let quicksandHeight: CGFloat = 10
    static let quicksandSinkRate: CGFloat = 2.0

    // MARK: - Treasure
    static let treasureSize = CGSize(width: 20, height: 16)

    // MARK: - Camera
    static let cameraLeadX: CGFloat = 50

    // MARK: - HUD
    static let heartSize: CGFloat = 10
    static let heartSpacing: CGFloat = 3
    static let hudTopMargin: CGFloat = 8
    static let progressBarHeight: CGFloat = 3
    static let progressBarWidth: CGFloat = 100

    #else
    // iPhone landscape — height scale: 320/224 ≈ 1.428; wide scene (568×320) for side-scrolling
    static let sceneSize = CGSize(width: 568, height: 320)
    static let sceneScale: CGFloat = 1.428

    // MARK: - Physics
    static let gravity: CGFloat = -12.85
    static let jumpVelocity: CGFloat = 714.0
    static let highJumpVelocity: CGFloat = 1000.0
    static let playerMass: CGFloat = 0.3

    // MARK: - Player
    static let playerSize = CGSize(width: 16, height: 16)
    static let playerCornerRadius: CGFloat = 3.0
    static let playerStartX: CGFloat = 60
    static let playerGroundY: CGFloat = 60

    // MARK: - Scrolling
    static let baseScrollSpeed: CGFloat = 58.0 // points per second
    static let levelLength: CGFloat = 5140.0

    // MARK: - Platform
    static let platformHeight: CGFloat = 12
    static let platformMinWidth: CGFloat = 36
    static let platformMaxWidth: CGFloat = 70
    static let movingPlatformSpeed: CGFloat = 43.0
    static let movingPlatformRange: CGFloat = 57.0

    // MARK: - Obstacles
    static let spikeWidth: CGFloat = 18
    static let spikeHeight: CGFloat = 20
    static let knifeSize: CGFloat = 20
    static let knifeSpeed: CGFloat = 48.0
    static let quicksandHeight: CGFloat = 15
    static let quicksandSinkRate: CGFloat = 3.0

    // MARK: - Treasure
    static let treasureSize = CGSize(width: 29, height: 23)

    // MARK: - Camera
    static let cameraLeadX: CGFloat = 72

    // MARK: - HUD
    static let heartSize: CGFloat = 15
    static let heartSpacing: CGFloat = 5
    static let hudTopMargin: CGFloat = 12
    static let progressBarHeight: CGFloat = 5
    static let progressBarWidth: CGFloat = 200
    #endif

    // MARK: - Timing (platform-independent)
    static let levelDuration: TimeInterval = 60.0
    static let doubleTapWindow: TimeInterval = 0.3
    static let quicksandTimer: TimeInterval = 10.0
    static let respawnDelay: TimeInterval = 1.0
    static let timedPlatformOnDuration: TimeInterval = 2.0
    static let timedPlatformOffDuration: TimeInterval = 1.5

    // MARK: - Lives
    static let maxLives: Int = 3

    // MARK: - Nodes
    static let maxActiveNodes: Int = 25

    // MARK: - Scrolling (platform-independent)
    static let crownSpeedRange: CGFloat = 0.10 // ±10%
}
