import SpriteKit

final class QuicksandNode: SKNode {
    let quicksandWidth: CGFloat
    private var visualNode: SKNode!

    init(width: CGFloat) {
        self.quicksandWidth = width
        super.init()
        name = "quicksand"
        setupVisual(width: width)
        setupPhysics(width: width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    private func setupVisual(width: CGFloat) {
        visualNode = SpriteFactory.makeQuicksand(width: width)
        addChild(visualNode)
    }

    private func setupPhysics(width: CGFloat) {
        let size = CGSize(width: width, height: Constants.quicksandHeight)
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.quicksand
        body.contactTestBitMask = PhysicsCategory.player
        body.collisionBitMask = PhysicsCategory.none
        physicsBody = body
    }
}
