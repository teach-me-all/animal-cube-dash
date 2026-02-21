import SpriteKit

struct ObstacleDrawing {

    // MARK: - Spike

    static func createSpike() -> SKNode {
        let parent = SKNode()
        parent.name = "spike"

        let w = Constants.spikeWidth
        let h = Constants.spikeHeight

        // Main spike body - slightly rounded cone
        let bodyPath = CGMutablePath()
        bodyPath.move(to: CGPoint(x: -w / 2, y: 0))
        bodyPath.addQuadCurve(
            to: CGPoint(x: 0, y: h),
            control: CGPoint(x: -w * 0.2, y: h * 0.7)
        )
        bodyPath.addQuadCurve(
            to: CGPoint(x: w / 2, y: 0),
            control: CGPoint(x: w * 0.2, y: h * 0.7)
        )
        bodyPath.closeSubpath()

        // Darker outline / base layer
        let outline = SKShapeNode(path: bodyPath)
        outline.fillColor = SKColor(hex: 0x636E72)   // dark gray
        outline.strokeColor = SKColor(hex: 0x4A5568)
        outline.lineWidth = 0.5
        parent.addChild(outline)

        // Glossy highlight on the upper left portion
        let glossPath = CGMutablePath()
        glossPath.move(to: CGPoint(x: -w * 0.25, y: h * 0.15))
        glossPath.addQuadCurve(
            to: CGPoint(x: -w * 0.05, y: h * 0.75),
            control: CGPoint(x: -w * 0.22, y: h * 0.5)
        )
        glossPath.addQuadCurve(
            to: CGPoint(x: -w * 0.05, y: h * 0.15),
            control: CGPoint(x: -w * 0.08, y: h * 0.4)
        )
        glossPath.closeSubpath()

        let gloss = SKShapeNode(path: glossPath)
        gloss.fillColor = SKColor(hex: 0xB2BEC3)     // light silver
        gloss.strokeColor = .clear
        gloss.lineWidth = 0
        gloss.alpha = 0.6
        parent.addChild(gloss)

        // Bright tip
        let tip = SKShapeNode(circleOfRadius: 1.0)
        tip.fillColor = SKColor(white: 0.95, alpha: 0.8)
        tip.strokeColor = .clear
        tip.lineWidth = 0
        tip.position = CGPoint(x: 0, y: h - 1.5)
        parent.addChild(tip)

        return parent
    }

    // MARK: - Quicksand

    static func createQuicksand(width: CGFloat) -> SKNode {
        let parent = SKNode()
        parent.name = "quicksand"

        let h = Constants.quicksandHeight

        // Base tan rectangle
        let baseRect = CGRect(x: -width / 2, y: -h / 2, width: width, height: h)
        let basePath = CGPath(roundedRect: baseRect, cornerWidth: 2, cornerHeight: 2, transform: nil)
        let base = SKShapeNode(path: basePath)
        base.fillColor = SKColor(hex: 0xDFBE8C)  // tan
        base.strokeColor = SKColor(hex: 0xC8A66A)
        base.lineWidth = 0.5
        parent.addChild(base)

        // Bubbly top surface - small circles along the top
        let bubbleCount = Int(width / 4)
        let bubbleY = h / 2 - 1.5
        for i in 0..<bubbleCount {
            let x = -width / 2 + CGFloat(i) * 4 + 2
            let radius: CGFloat = CGFloat.random(in: 0.8...1.5)
            let bubble = SKShapeNode(circleOfRadius: radius)
            bubble.fillColor = SKColor(hex: 0xC8A66A)
            bubble.strokeColor = SKColor(hex: 0xB8965A)
            bubble.lineWidth = 0.3
            bubble.position = CGPoint(x: x, y: bubbleY - CGFloat.random(in: 0...1))
            parent.addChild(bubble)
        }

        // Darker bottom edge
        let bottomEdge = SKShapeNode(rect: CGRect(x: -width / 2, y: -h / 2, width: width, height: 2))
        bottomEdge.fillColor = SKColor(hex: 0xB8965A)
        bottomEdge.strokeColor = .clear
        bottomEdge.lineWidth = 0
        parent.addChild(bottomEdge)

        return parent
    }

    // MARK: - Flying Knife (toy pinwheel)

    static func createFlyingKnife() -> SKNode {
        let parent = SKNode()
        parent.name = "knife"

        let size = Constants.knifeSize
        let halfSize = size / 2

        // Pinwheel / star shape with 4 rounded blades
        let bladePath = CGMutablePath()
        let bladeCount = 4

        for i in 0..<bladeCount {
            let angle = CGFloat(i) * (.pi * 2 / CGFloat(bladeCount))
            let nextAngle = angle + .pi * 2 / CGFloat(bladeCount) / 2

            let tipX = cos(angle) * halfSize
            let tipY = sin(angle) * halfSize
            let midX = cos(nextAngle) * halfSize * 0.3
            let midY = sin(nextAngle) * halfSize * 0.3

            bladePath.move(to: .zero)
            bladePath.addQuadCurve(
                to: CGPoint(x: tipX, y: tipY),
                control: CGPoint(x: cos(angle - 0.3) * halfSize * 0.6,
                                 y: sin(angle - 0.3) * halfSize * 0.6)
            )
            bladePath.addQuadCurve(
                to: .zero,
                control: CGPoint(x: midX, y: midY)
            )
        }

        let blades = SKShapeNode(path: bladePath)
        blades.fillColor = SKColor(hex: 0xB2BEC3)  // silver
        blades.strokeColor = SKColor(hex: 0x636E72)
        blades.lineWidth = 0.5
        blades.name = "blades"
        parent.addChild(blades)

        // Colorful center hub
        let center = SKShapeNode(circleOfRadius: size * 0.15)
        center.fillColor = SKColor(hex: 0xE17055)   // coral/red
        center.strokeColor = SKColor(hex: 0xD63031)
        center.lineWidth = 0.5
        center.zPosition = 1
        parent.addChild(center)

        // Tiny inner dot
        let dot = SKShapeNode(circleOfRadius: size * 0.06)
        dot.fillColor = SKColor(hex: 0xFDCB6E)  // yellow
        dot.strokeColor = .clear
        dot.lineWidth = 0
        dot.zPosition = 2
        parent.addChild(dot)

        return parent
    }

    // MARK: - Timer Ring

    static func createTimerRing(radius: CGFloat) -> SKShapeNode {
        let path = CGMutablePath()
        path.addArc(center: .zero, radius: radius,
                    startAngle: .pi / 2, endAngle: .pi / 2 - 0.001,
                    clockwise: true)

        let ring = SKShapeNode(path: path)
        ring.strokeColor = SKColor(hex: 0x00B894) // green
        ring.fillColor = .clear
        ring.lineWidth = 2.0
        ring.lineCap = .round
        ring.name = "timerRing"
        return ring
    }

    // MARK: - Warning Glow

    static func createWarningGlow() -> SKShapeNode {
        let glow = SKShapeNode(circleOfRadius: Constants.knifeSize * 0.8)
        glow.fillColor = SKColor(hex: 0xFDCB6E, alpha: 0.3)  // yellow
        glow.strokeColor = SKColor(hex: 0xE17055, alpha: 0.5) // orange
        glow.lineWidth = 1.0
        glow.glowWidth = 3.0
        glow.name = "warningGlow"
        return glow
    }
}
