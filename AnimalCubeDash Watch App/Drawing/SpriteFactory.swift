import SpriteKit

struct SpriteFactory {

    // MARK: - Player

    static func makePlayer(skin: AnimalSkin) -> SKNode {
        return CubeDrawing.createCube(skin: skin)
    }

    // MARK: - Platform

    static func makePlatform(width: CGFloat, type: PlatformType) -> SKNode {
        let topColor: SKColor
        let frontColor: SKColor
        let highlightColor: SKColor
        let outlineColor: SKColor

        switch type {
        case .static_:
            topColor = SKColor(hex: 0xD4A843)        // sandy gold top
            frontColor = SKColor(hex: 0xA07830)       // darker front depth
            highlightColor = SKColor(hex: 0xE8C060)   // light edge highlight
            outlineColor = SKColor(hex: 0x8B6914)
        case .movingH, .movingV:
            topColor = SKColor(hex: 0x74B9FF)         // blue top
            frontColor = SKColor(hex: 0x4A8CC7)       // darker blue front
            highlightColor = SKColor(hex: 0x9DD3FF)   // light blue highlight
            outlineColor = SKColor(hex: 0x3A7AB8)
        case .timed:
            topColor = SKColor(hex: 0xFDCB6E)         // yellow top
            frontColor = SKColor(hex: 0xC9A04A)       // darker yellow front
            highlightColor = SKColor(hex: 0xFFE08A)   // light yellow highlight
            outlineColor = SKColor(hex: 0xB08E3A)
        }

        let parent = SKNode()
        parent.name = "platform"

        let h = Constants.platformHeight
        let depth: CGFloat = 5  // visible depth below the top face
        let cornerR: CGFloat = 2.0

        // Front face (depth) — drawn first, sits below the top face
        let frontRect = CGRect(x: -width / 2, y: -h / 2 - depth, width: width, height: depth + 1)
        let frontPath = CGPath(roundedRect: frontRect, cornerWidth: cornerR, cornerHeight: cornerR, transform: nil)
        let front = SKShapeNode(path: frontPath)
        front.fillColor = frontColor
        front.strokeColor = outlineColor
        front.lineWidth = 0.5
        parent.addChild(front)

        // Top face
        let topRect = CGRect(x: -width / 2, y: -h / 2, width: width, height: h)
        let topPath = CGPath(roundedRect: topRect, cornerWidth: cornerR, cornerHeight: cornerR, transform: nil)
        let top = SKShapeNode(path: topPath)
        top.fillColor = topColor
        top.strokeColor = outlineColor
        top.lineWidth = 0.5
        parent.addChild(top)

        // Top edge highlight — a thin lighter strip along the top
        let highlightRect = CGRect(x: -width / 2 + 1, y: h / 2 - 2, width: width - 2, height: 1.5)
        let highlight = SKShapeNode(rect: highlightRect)
        highlight.fillColor = highlightColor
        highlight.strokeColor = .clear
        highlight.lineWidth = 0
        highlight.alpha = 0.6
        parent.addChild(highlight)

        return parent
    }

    // MARK: - Spike

    static func makeSpike(variant: SpikeVariant) -> SKNode {
        let spike = ObstacleDrawing.createSpike()

        // Visually distinguish variants with a subtle tint on the base
        switch variant {
        case .static_:
            break // default silver look
        case .popup:
            // Add a small base indicator
            let baseIndicator = SKShapeNode(rect: CGRect(
                x: -Constants.spikeWidth / 2 - 1,
                y: -2,
                width: Constants.spikeWidth + 2,
                height: 2
            ))
            baseIndicator.fillColor = SKColor(hex: 0xE17055)
            baseIndicator.strokeColor = .clear
            baseIndicator.lineWidth = 0
            spike.addChild(baseIndicator)
        case .rail:
            // Add a small rail line underneath
            let rail = SKShapeNode(rect: CGRect(
                x: -Constants.spikeWidth / 2 - 2,
                y: -1.5,
                width: Constants.spikeWidth + 4,
                height: 1.5
            ))
            rail.fillColor = SKColor(hex: 0x636E72)
            rail.strokeColor = .clear
            rail.lineWidth = 0
            spike.addChild(rail)
        }

        return spike
    }

    // MARK: - Quicksand

    static func makeQuicksand(width: CGFloat) -> SKNode {
        return ObstacleDrawing.createQuicksand(width: width)
    }

    // MARK: - Knife

    static func makeKnife() -> SKNode {
        return ObstacleDrawing.createFlyingKnife()
    }

    // MARK: - Treasure Chest

    static func makeTreasureChest() -> SKNode {
        let parent = SKNode()
        parent.name = "treasureChest"

        let w = Constants.treasureSize.width
        let h = Constants.treasureSize.height
        let lidHeight = h * 0.4
        let baseHeight = h * 0.6

        // Brown base
        let baseRect = CGRect(x: -w / 2, y: -h / 2, width: w, height: baseHeight)
        let basePath = CGPath(roundedRect: baseRect, cornerWidth: 2, cornerHeight: 2, transform: nil)
        let base = SKShapeNode(path: basePath)
        base.fillColor = SKColor(hex: 0x8B6914)
        base.strokeColor = SKColor(hex: 0x6D5210)
        base.lineWidth = 0.5
        parent.addChild(base)

        // Gold lid with slight curve on top
        let lidPath = CGMutablePath()
        let lidBottom = -h / 2 + baseHeight
        lidPath.move(to: CGPoint(x: -w / 2, y: lidBottom))
        lidPath.addLine(to: CGPoint(x: -w / 2, y: lidBottom + lidHeight * 0.6))
        lidPath.addQuadCurve(
            to: CGPoint(x: w / 2, y: lidBottom + lidHeight * 0.6),
            control: CGPoint(x: 0, y: lidBottom + lidHeight)
        )
        lidPath.addLine(to: CGPoint(x: w / 2, y: lidBottom))
        lidPath.closeSubpath()

        let lid = SKShapeNode(path: lidPath)
        lid.fillColor = SKColor(hex: 0xFDCB6E)
        lid.strokeColor = SKColor(hex: 0xD4A843)
        lid.lineWidth = 0.5
        parent.addChild(lid)

        // Small lock/clasp in center
        let clasp = SKShapeNode(circleOfRadius: 1.5)
        clasp.fillColor = SKColor(hex: 0xD4A843)
        clasp.strokeColor = SKColor(hex: 0xB8922E)
        clasp.lineWidth = 0.3
        clasp.position = CGPoint(x: 0, y: lidBottom)
        parent.addChild(clasp)

        return parent
    }

    // MARK: - Heart

    static func makeHeart(filled: Bool) -> SKNode {
        let size = Constants.heartSize
        let parent = SKNode()
        parent.name = "heart"

        let path = heartPath(size: size)
        let heart = SKShapeNode(path: path)

        if filled {
            heart.fillColor = SKColor(hex: 0xE74C3C)
            heart.strokeColor = SKColor(hex: 0xC0392B)
        } else {
            heart.fillColor = .clear
            heart.strokeColor = SKColor(hex: 0x95A5A6)
        }
        heart.lineWidth = 0.8
        parent.addChild(heart)

        return parent
    }

    // MARK: - Progress Bar

    static func makeProgressBar() -> SKNode {
        let parent = SKNode()
        parent.name = "progressBar"

        let w = Constants.progressBarWidth
        let h = Constants.progressBarHeight

        // Background track
        let bgRect = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)
        let bgPath = CGPath(roundedRect: bgRect, cornerWidth: h / 2, cornerHeight: h / 2, transform: nil)
        let bg = SKShapeNode(path: bgPath)
        bg.fillColor = SKColor(white: 0.3, alpha: 0.5)
        bg.strokeColor = .clear
        bg.lineWidth = 0
        bg.name = "progressBg"
        parent.addChild(bg)

        // Fill bar (starts at zero width, scale to show progress)
        let fillRect = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)
        let fillPath = CGPath(roundedRect: fillRect, cornerWidth: h / 2, cornerHeight: h / 2, transform: nil)
        let fill = SKShapeNode(path: fillPath)
        fill.fillColor = SKColor(hex: 0x00B894)
        fill.strokeColor = .clear
        fill.lineWidth = 0
        fill.name = "progressFill"
        fill.xScale = 0.0
        parent.addChild(fill)

        return parent
    }

    // MARK: - Heart Path Helper

    private static func heartPath(size: CGFloat) -> CGPath {
        let s = size
        let path = CGMutablePath()

        // Heart shape centered at origin
        path.move(to: CGPoint(x: 0, y: -s * 0.35))
        path.addCurve(
            to: CGPoint(x: -s / 2, y: s * 0.15),
            control1: CGPoint(x: -s * 0.05, y: -s * 0.1),
            control2: CGPoint(x: -s / 2, y: -s * 0.1)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: s * 0.4),
            control1: CGPoint(x: -s / 2, y: s * 0.35),
            control2: CGPoint(x: -s * 0.15, y: s * 0.45)
        )
        path.addCurve(
            to: CGPoint(x: s / 2, y: s * 0.15),
            control1: CGPoint(x: s * 0.15, y: s * 0.45),
            control2: CGPoint(x: s / 2, y: s * 0.35)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: -s * 0.35),
            control1: CGPoint(x: s / 2, y: -s * 0.1),
            control2: CGPoint(x: s * 0.05, y: -s * 0.1)
        )
        path.closeSubpath()

        return path
    }
}
