import SpriteKit

final class ScrollController {
    private(set) var scrollSpeed: CGFloat
    private(set) var crownOffset: CGFloat = 0
    private(set) var scrollPosition: CGFloat = 0
    private var baseSpeed: CGFloat

    var effectiveSpeed: CGFloat {
        baseSpeed * (1.0 + crownOffset)
    }

    var progress: CGFloat {
        scrollPosition / Constants.levelLength
    }

    init(baseSpeed: CGFloat = Constants.baseScrollSpeed) {
        self.baseSpeed = baseSpeed
        self.scrollSpeed = baseSpeed
    }

    func update(deltaTime: TimeInterval) {
        scrollSpeed = effectiveSpeed
        scrollPosition += scrollSpeed * CGFloat(deltaTime)
    }

    func updateCrown(value: Double) {
        // Crown value mapped to ±10% speed adjustment
        crownOffset = CGFloat(max(-Constants.crownSpeedRange, min(Constants.crownSpeedRange, value)))
    }

    func resetCrown() {
        crownOffset = 0
    }

    func reset() {
        scrollPosition = 0
        crownOffset = 0
        scrollSpeed = baseSpeed
    }

    func setScrollPosition(_ position: CGFloat) {
        scrollPosition = position
    }

    func setBaseSpeed(_ speed: CGFloat) {
        baseSpeed = speed
    }
}
