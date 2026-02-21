import SpriteKit

struct EnvironmentDrawing {

    // MARK: - Sky Background

    static func createSkyBackground(size: CGSize) -> SKNode {
        let parent = SKNode()
        parent.name = "skyBackground"

        let bandCount = 12
        let bandHeight = size.height / CGFloat(bandCount)

        let topColor = SKColor(hex: 0x74B9FF)    // light blue
        let bottomColor = SKColor(hex: 0xDFE6E9)  // pale blue-white

        for i in 0..<bandCount {
            let t = CGFloat(i) / CGFloat(bandCount - 1)
            let color = lerpColor(from: topColor, to: bottomColor, t: t)

            let bandRect = CGRect(
                x: -size.width / 2,
                y: size.height / 2 - CGFloat(i + 1) * bandHeight,
                width: size.width,
                height: bandHeight + 0.5
            )
            let band = SKShapeNode(rect: bandRect)
            band.fillColor = color
            band.strokeColor = .clear
            band.lineWidth = 0
            parent.addChild(band)
        }

        return parent
    }

    // MARK: - Cloud

    static func createCloud() -> SKShapeNode {
        let cloud = SKShapeNode()
        let path = CGMutablePath()

        path.addEllipse(in: CGRect(x: -10, y: -3, width: 10, height: 7))
        path.addEllipse(in: CGRect(x: -5, y: 0, width: 12, height: 9))
        path.addEllipse(in: CGRect(x: 2, y: -2, width: 9, height: 7))
        path.addEllipse(in: CGRect(x: -8, y: -5, width: 14, height: 6))

        cloud.path = path
        cloud.fillColor = SKColor(white: 1.0, alpha: 0.9)
        cloud.strokeColor = .clear
        cloud.lineWidth = 0
        cloud.name = "cloud"
        return cloud
    }

    // MARK: - Island / Platform Ground

    static func createIsland(width: CGFloat) -> SKNode {
        let parent = SKNode()
        parent.name = "island"

        let height: CGFloat = Constants.platformHeight
        let curveDepth: CGFloat = 3.0

        // Green top with slight curve
        let topPath = CGMutablePath()
        topPath.move(to: CGPoint(x: -width / 2, y: 0))
        topPath.addQuadCurve(
            to: CGPoint(x: width / 2, y: 0),
            control: CGPoint(x: 0, y: curveDepth)
        )
        topPath.addLine(to: CGPoint(x: width / 2, y: -height * 0.4))
        topPath.addLine(to: CGPoint(x: -width / 2, y: -height * 0.4))
        topPath.closeSubpath()

        let grass = SKShapeNode(path: topPath)
        grass.fillColor = SKColor(hex: 0x00B894)
        grass.strokeColor = SKColor(hex: 0x00A383)
        grass.lineWidth = 0.5
        parent.addChild(grass)

        // Brown dirt underneath
        let dirtRect = CGRect(
            x: -width / 2,
            y: -height,
            width: width,
            height: height * 0.6
        )
        let dirtPath = CGPath(
            roundedRect: dirtRect,
            cornerWidth: 2,
            cornerHeight: 2,
            transform: nil
        )
        let dirt = SKShapeNode(path: dirtPath)
        dirt.fillColor = SKColor(hex: 0x8B6914)
        dirt.strokeColor = SKColor(hex: 0x7A5C12)
        dirt.lineWidth = 0.5
        parent.addChild(dirt)

        return parent
    }

    // MARK: - Parallax Layer

    static func createParallaxLayer(sceneSize: CGSize) -> SKNode {
        let layer = SKNode()
        layer.name = "parallaxLayer"

        let cloudConfigs: [(x: CGFloat, y: CGFloat, scale: CGFloat)] = [
            (-sceneSize.width * 0.35, sceneSize.height * 0.3, 0.6),
            (sceneSize.width * 0.1, sceneSize.height * 0.35, 0.8),
            (sceneSize.width * 0.4, sceneSize.height * 0.25, 0.5),
            (-sceneSize.width * 0.1, sceneSize.height * 0.4, 0.7),
        ]

        for config in cloudConfigs {
            let cloud = createCloud()
            cloud.position = CGPoint(x: config.x, y: config.y)
            cloud.setScale(config.scale)
            cloud.alpha = 0.6 + config.scale * 0.3
            layer.addChild(cloud)
        }

        return layer
    }

    // MARK: - Helpers

    private static func lerpColor(from: SKColor, to: SKColor, t: CGFloat) -> SKColor {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        from.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        to.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return SKColor(
            red: r1 + (r2 - r1) * t,
            green: g1 + (g2 - g1) * t,
            blue: b1 + (b2 - b1) * t,
            alpha: a1 + (a2 - a1) * t
        )
    }
}
