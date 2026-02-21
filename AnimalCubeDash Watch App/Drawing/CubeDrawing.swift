import SpriteKit

enum CubeExpression {
    case normal, happy, surprised, sad
}

struct CubeDrawing {

    // MARK: - Main Factory

    static func createCube(skin: AnimalSkin) -> SKNode {
        let parent = SKNode()
        parent.name = "cubeRoot"

        // Body
        let body = SKShapeNode.roundedRect(
            size: Constants.playerSize,
            cornerRadius: Constants.playerCornerRadius,
            color: skin.bodyColor
        )
        body.name = "body"
        parent.addChild(body)

        // Ears (behind body)
        addEars(to: parent, skin: skin)

        // Eyes (big kawaii eyes)
        addKawaiiEyes(to: parent, skin: skin)

        // Blush circles on cheeks
        addBlush(to: parent)

        // Mouth (default normal - cute cat mouth)
        let mouth = createMouthNode(expression: .normal, skin: skin)
        mouth.name = "mouth"
        parent.addChild(mouth)

        // Small nose
        addNose(to: parent, skin: skin)

        return parent
    }

    // MARK: - Expression

    static func setExpression(_ node: SKNode, expression: CubeExpression) {
        node.childNode(withName: "mouth")?.removeFromParent()
        // Try to determine skin from body color, default to cat-style mouth
        let mouth = createMouthNode(expression: expression, skin: nil)
        mouth.name = "mouth"
        node.addChild(mouth)
    }

    // MARK: - Kawaii Eyes

    private static func addKawaiiEyes(to parent: SKNode, skin: AnimalSkin) {
        let eyeOffsetX: CGFloat = 3.8
        let eyeY: CGFloat = 1.5
        let eyeRadius: CGFloat = 3.2
        let pupilRadius: CGFloat = 2.2

        for side: CGFloat in [-1, 1] {
            // White of eye
            let eyeWhite = SKShapeNode(circleOfRadius: eyeRadius)
            eyeWhite.fillColor = .white
            eyeWhite.strokeColor = SKColor(white: 0.8, alpha: 1)
            eyeWhite.lineWidth = 0.4
            eyeWhite.position = CGPoint(x: side * eyeOffsetX, y: eyeY)
            parent.addChild(eyeWhite)

            // Big pupil (fills most of eye for kawaii look)
            let pupil = SKShapeNode(circleOfRadius: pupilRadius)
            pupil.fillColor = SKColor(hex: 0x2D3436)
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            pupil.position = CGPoint(x: side * 0.3, y: -0.2)
            eyeWhite.addChild(pupil)

            // Large sparkle highlight (top-right of pupil)
            let sparkle = SKShapeNode(circleOfRadius: 0.9)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.lineWidth = 0
            sparkle.position = CGPoint(x: side * 0.5, y: 0.6)
            pupil.addChild(sparkle)

            // Small secondary sparkle
            let sparkle2 = SKShapeNode(circleOfRadius: 0.4)
            sparkle2.fillColor = .white
            sparkle2.strokeColor = .clear
            sparkle2.lineWidth = 0
            sparkle2.position = CGPoint(x: side * -0.3, y: -0.4)
            pupil.addChild(sparkle2)
        }
    }

    // MARK: - Blush

    private static func addBlush(to parent: SKNode) {
        let blushY: CGFloat = -1.0
        let blushOffsetX: CGFloat = 5.5

        for side: CGFloat in [-1, 1] {
            let blush = SKShapeNode(ellipseOf: CGSize(width: 3.0, height: 1.8))
            blush.fillColor = SKColor(red: 1.0, green: 0.6, blue: 0.7, alpha: 0.45)
            blush.strokeColor = .clear
            blush.lineWidth = 0
            blush.position = CGPoint(x: side * blushOffsetX, y: blushY)
            parent.addChild(blush)
        }
    }

    // MARK: - Nose

    private static func addNose(to parent: SKNode, skin: AnimalSkin) {
        let noseY: CGFloat = -1.2

        switch skin {
        case .cat, .tiger:
            // Tiny triangle nose
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: noseY + 0.5))
            path.addLine(to: CGPoint(x: -0.8, y: noseY - 0.5))
            path.addLine(to: CGPoint(x: 0.8, y: noseY - 0.5))
            path.closeSubpath()
            let nose = SKShapeNode(path: path)
            nose.fillColor = SKColor(hex: 0xE17055)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            parent.addChild(nose)

        case .dog:
            // Round black nose
            let nose = SKShapeNode(circleOfRadius: 1.0)
            nose.fillColor = SKColor(hex: 0x2D3436)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .panda:
            // Small oval nose
            let nose = SKShapeNode(ellipseOf: CGSize(width: 2.0, height: 1.2))
            nose.fillColor = SKColor(hex: 0x2D3436)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .dragon:
            // Two tiny nostrils
            for side: CGFloat in [-1, 1] {
                let nostril = SKShapeNode(circleOfRadius: 0.5)
                nostril.fillColor = SKColor(hex: 0x4B3D8F)
                nostril.strokeColor = .clear
                nostril.lineWidth = 0
                nostril.position = CGPoint(x: side * 1.0, y: noseY)
                parent.addChild(nostril)
            }

        case .bunny, .fox, .arcticFox, .wolf, .raccoon, .redPanda, .deer:
            // Tiny triangle nose
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: noseY + 0.5))
            path.addLine(to: CGPoint(x: -0.8, y: noseY - 0.5))
            path.addLine(to: CGPoint(x: 0.8, y: noseY - 0.5))
            path.closeSubpath()
            let nose = SKShapeNode(path: path)
            nose.fillColor = SKColor(hex: 0xE17055)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            parent.addChild(nose)

        case .hamster, .koala:
            // Small round nose
            let nose = SKShapeNode(circleOfRadius: 0.8)
            nose.fillColor = SKColor(hex: 0xE17055)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .lion, .goldenTiger:
            // Wider triangle nose
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: noseY + 0.7))
            path.addLine(to: CGPoint(x: -1.2, y: noseY - 0.5))
            path.addLine(to: CGPoint(x: 1.2, y: noseY - 0.5))
            path.closeSubpath()
            let nose = SKShapeNode(path: path)
            nose.fillColor = SKColor(hex: 0xD35400)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            parent.addChild(nose)

        case .chick, .duck:
            // Small beak
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -1.2, y: noseY + 0.3))
            path.addLine(to: CGPoint(x: 1.2, y: noseY + 0.3))
            path.addLine(to: CGPoint(x: 0, y: noseY - 0.8))
            path.closeSubpath()
            let beak = SKShapeNode(path: path)
            beak.fillColor = SKColor(hex: 0xFF8F00)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            parent.addChild(beak)

        case .dolphin:
            // Small snout dot
            let nose = SKShapeNode(circleOfRadius: 0.5)
            nose.fillColor = SKColor(hex: 0x0984E3)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .shark:
            // Wide nostrils
            for side: CGFloat in [-1, 1] {
                let nostril = SKShapeNode(circleOfRadius: 0.4)
                nostril.fillColor = SKColor(hex: 0x34495E)
                nostril.strokeColor = .clear
                nostril.lineWidth = 0
                nostril.position = CGPoint(x: side * 1.2, y: noseY)
                parent.addChild(nostril)
            }

        case .chameleon:
            // Two tiny dots
            for side: CGFloat in [-1, 1] {
                let nostril = SKShapeNode(circleOfRadius: 0.4)
                nostril.fillColor = SKColor(hex: 0x00A844)
                nostril.strokeColor = .clear
                nostril.lineWidth = 0
                nostril.position = CGPoint(x: side * 0.8, y: noseY)
                parent.addChild(nostril)
            }

        case .phoenix:
            // Small pointed beak
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -1.0, y: noseY + 0.4))
            path.addLine(to: CGPoint(x: 1.0, y: noseY + 0.4))
            path.addLine(to: CGPoint(x: 0, y: noseY - 1.2))
            path.closeSubpath()
            let beak = SKShapeNode(path: path)
            beak.fillColor = SKColor(hex: 0xFFC312)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            parent.addChild(beak)

        case .unicorn:
            // Tiny pink nose
            let nose = SKShapeNode(circleOfRadius: 0.7)
            nose.fillColor = SKColor(hex: 0xF8A5C2)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .owl, .snowyOwl:
            // Small beak triangle pointing down
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -1.0, y: noseY + 0.5))
            path.addLine(to: CGPoint(x: 1.0, y: noseY + 0.5))
            path.addLine(to: CGPoint(x: 0, y: noseY - 1.0))
            path.closeSubpath()
            let beak = SKShapeNode(path: path)
            beak.fillColor = SKColor(hex: 0xE8A640)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            parent.addChild(beak)

        case .frog:
            // Two wide nostrils
            for side: CGFloat in [-1, 1] {
                let nostril = SKShapeNode(circleOfRadius: 0.6)
                nostril.fillColor = SKColor(hex: 0x1D8348)
                nostril.strokeColor = .clear
                nostril.lineWidth = 0
                nostril.position = CGPoint(x: side * 1.5, y: noseY)
                parent.addChild(nostril)
            }

        case .penguin:
            // Small oval beak
            let beak = SKShapeNode(ellipseOf: CGSize(width: 2.5, height: 1.2))
            beak.fillColor = SKColor(hex: 0xF39C12)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            beak.position = CGPoint(x: 0, y: noseY)
            parent.addChild(beak)

        case .helloKitty:
            // Tiny yellow oval nose (Hello Kitty has no mouth, just a nose)
            let nose = SKShapeNode(ellipseOf: CGSize(width: 1.8, height: 1.4))
            nose.fillColor = SKColor(hex: 0xFFD700)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .myMelody:
            // Small pink oval nose
            let nose = SKShapeNode(ellipseOf: CGSize(width: 1.6, height: 1.2))
            nose.fillColor = SKColor(hex: 0xFF69B4)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .cinnamoroll:
            // Tiny round pink nose
            let nose = SKShapeNode(circleOfRadius: 0.7)
            nose.fillColor = SKColor(hex: 0xFFB6C1)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .kuromi:
            // Small skull-like nose dot
            let nose = SKShapeNode(circleOfRadius: 0.6)
            nose.fillColor = SKColor(hex: 0xCE93D8)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .pompompurin:
            // Round brown nose
            let nose = SKShapeNode(circleOfRadius: 1.0)
            nose.fillColor = SKColor(hex: 0x8D6E63)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .keroppi:
            // Wide frog nostrils
            for side: CGFloat in [-1, 1] {
                let nostril = SKShapeNode(circleOfRadius: 0.6)
                nostril.fillColor = SKColor(hex: 0x2E7D32)
                nostril.strokeColor = .clear
                nostril.lineWidth = 0
                nostril.position = CGPoint(x: side * 1.5, y: noseY)
                parent.addChild(nostril)
            }

        case .pochacco:
            // Round dog nose
            let nose = SKShapeNode(circleOfRadius: 1.0)
            nose.fillColor = SKColor(hex: 0x2D3436)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .badtzMaru:
            // Small beak
            let path = CGMutablePath()
            path.move(to: CGPoint(x: -1.2, y: noseY + 0.3))
            path.addLine(to: CGPoint(x: 1.2, y: noseY + 0.3))
            path.addLine(to: CGPoint(x: 0, y: noseY - 1.0))
            path.closeSubpath()
            let beak = SKShapeNode(path: path)
            beak.fillColor = SKColor(hex: 0xFFA726)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            parent.addChild(beak)

        case .tuxedoSam:
            // Small penguin beak
            let beak = SKShapeNode(ellipseOf: CGSize(width: 2.5, height: 1.2))
            beak.fillColor = SKColor(hex: 0xFFA726)
            beak.strokeColor = .clear
            beak.lineWidth = 0
            beak.position = CGPoint(x: 0, y: noseY)
            parent.addChild(beak)

        case .littleTwinStars:
            // Tiny pink nose
            let nose = SKShapeNode(circleOfRadius: 0.6)
            nose.fillColor = SKColor(hex: 0xF48FB1)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .blueTwinStar:
            // Tiny blue nose
            let nose = SKShapeNode(circleOfRadius: 0.6)
            nose.fillColor = SKColor(hex: 0x42A5F5)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)
        }
    }

    // MARK: - Ears

    private static func addEars(to parent: SKNode, skin: AnimalSkin) {
        let halfW = Constants.playerSize.width / 2
        let halfH = Constants.playerSize.height / 2

        switch skin.earStyle {
        case .pointed:
            addPointedEars(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor, innerColor: SKColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0))
        case .floppy:
            addFloppyEars(to: parent, halfW: halfW, halfH: halfH, color: darkenColor(skin.bodyColor))
        case .round:
            addRoundEars(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .horn:
            addHornEars(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .tall:
            addTallEars(to: parent, halfW: halfW, halfH: halfH, color: skin.bodyColor, innerColor: SKColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0))
        case .tuft:
            addTuftEars(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .antler:
            addAntlers(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .sanrioBow:
            addSanrioBow(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .sanrioHood:
            addSanrioHood(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .sanrioJester:
            addSanrioJester(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .sanrioBeret:
            addSanrioBeret(to: parent, halfW: halfW, halfH: halfH, color: skin.accentColor)
        case .none:
            break
        }
    }

    private static func addPointedEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor, innerColor: SKColor) {
        for side: CGFloat in [-1, 1] {
            // Outer ear
            let path = CGMutablePath()
            let baseX = side * (halfW - 2)
            path.move(to: CGPoint(x: baseX - 3, y: halfH - 1))
            path.addLine(to: CGPoint(x: baseX, y: halfH + 6))
            path.addLine(to: CGPoint(x: baseX + 3, y: halfH - 1))
            path.closeSubpath()

            let ear = SKShapeNode(path: path)
            ear.fillColor = color
            ear.strokeColor = color.withAlphaComponent(0.7)
            ear.lineWidth = 0.5
            parent.addChild(ear)

            // Inner ear (pink)
            let innerPath = CGMutablePath()
            innerPath.move(to: CGPoint(x: baseX - 1.5, y: halfH))
            innerPath.addLine(to: CGPoint(x: baseX, y: halfH + 4))
            innerPath.addLine(to: CGPoint(x: baseX + 1.5, y: halfH))
            innerPath.closeSubpath()

            let innerEar = SKShapeNode(path: innerPath)
            innerEar.fillColor = innerColor
            innerEar.strokeColor = .clear
            innerEar.lineWidth = 0
            parent.addChild(innerEar)
        }
    }

    private static func addFloppyEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        for side: CGFloat in [-1, 1] {
            let earRect = CGRect(x: -2, y: -5, width: 4, height: 6)
            let earPath = CGPath(roundedRect: earRect, cornerWidth: 2, cornerHeight: 2, transform: nil)
            let ear = SKShapeNode(path: earPath)
            ear.fillColor = color
            ear.strokeColor = color.withAlphaComponent(0.7)
            ear.lineWidth = 0.5
            ear.position = CGPoint(x: side * (halfW + 1.5), y: halfH - 4)
            ear.zRotation = side * -0.3
            parent.addChild(ear)
        }
    }

    private static func addRoundEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        for side: CGFloat in [-1, 1] {
            // Outer circle
            let ear = SKShapeNode(circleOfRadius: 3.5)
            ear.fillColor = color
            ear.strokeColor = color.withAlphaComponent(0.7)
            ear.lineWidth = 0.5
            ear.position = CGPoint(x: side * (halfW - 1.5), y: halfH + 2.5)
            parent.addChild(ear)

            // Inner circle (lighter)
            let inner = SKShapeNode(circleOfRadius: 2.0)
            inner.fillColor = SKColor(white: 0.9, alpha: 0.6)
            inner.strokeColor = .clear
            inner.lineWidth = 0
            inner.position = CGPoint(x: 0, y: 0.3)
            ear.addChild(inner)
        }
    }

    private static func addHornEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        for side: CGFloat in [-1, 1] {
            let path = CGMutablePath()
            let baseX = side * (halfW - 3)
            path.move(to: CGPoint(x: baseX - 2, y: halfH - 1))
            path.addLine(to: CGPoint(x: baseX + side * 1, y: halfH + 7))
            path.addLine(to: CGPoint(x: baseX + 2, y: halfH - 1))
            path.closeSubpath()

            let horn = SKShapeNode(path: path)
            horn.fillColor = color
            horn.strokeColor = color.withAlphaComponent(0.7)
            horn.lineWidth = 0.5
            parent.addChild(horn)

            // Sparkle at tip
            let tip = SKShapeNode(circleOfRadius: 0.6)
            tip.fillColor = .white
            tip.strokeColor = .clear
            tip.lineWidth = 0
            tip.position = CGPoint(x: baseX + side * 1, y: halfH + 7)
            parent.addChild(tip)
        }
    }

    private static func addTallEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor, innerColor: SKColor) {
        for side: CGFloat in [-1, 1] {
            // Tall bunny ear
            let path = CGMutablePath()
            let baseX = side * (halfW - 3)
            path.move(to: CGPoint(x: baseX - 2.5, y: halfH - 1))
            path.addQuadCurve(
                to: CGPoint(x: baseX, y: halfH + 10),
                control: CGPoint(x: baseX - 2, y: halfH + 6)
            )
            path.addQuadCurve(
                to: CGPoint(x: baseX + 2.5, y: halfH - 1),
                control: CGPoint(x: baseX + 2, y: halfH + 6)
            )
            path.closeSubpath()

            let ear = SKShapeNode(path: path)
            ear.fillColor = color
            ear.strokeColor = color.withAlphaComponent(0.7)
            ear.lineWidth = 0.5
            parent.addChild(ear)

            // Inner ear (pink)
            let innerPath = CGMutablePath()
            innerPath.move(to: CGPoint(x: baseX - 1.2, y: halfH))
            innerPath.addQuadCurve(
                to: CGPoint(x: baseX, y: halfH + 7),
                control: CGPoint(x: baseX - 1, y: halfH + 4)
            )
            innerPath.addQuadCurve(
                to: CGPoint(x: baseX + 1.2, y: halfH),
                control: CGPoint(x: baseX + 1, y: halfH + 4)
            )
            innerPath.closeSubpath()

            let innerEar = SKShapeNode(path: innerPath)
            innerEar.fillColor = innerColor
            innerEar.strokeColor = .clear
            innerEar.lineWidth = 0
            parent.addChild(innerEar)
        }
    }

    private static func addTuftEars(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        for side: CGFloat in [-1, 1] {
            // Small feather tuft
            let path = CGMutablePath()
            let baseX = side * (halfW - 2)
            path.move(to: CGPoint(x: baseX - 2, y: halfH))
            path.addLine(to: CGPoint(x: baseX - 1, y: halfH + 5))
            path.addLine(to: CGPoint(x: baseX + 0.5, y: halfH + 3))
            path.addLine(to: CGPoint(x: baseX + 1.5, y: halfH + 6))
            path.addLine(to: CGPoint(x: baseX + 2, y: halfH))
            path.closeSubpath()

            let tuft = SKShapeNode(path: path)
            tuft.fillColor = color
            tuft.strokeColor = color.withAlphaComponent(0.7)
            tuft.lineWidth = 0.5
            parent.addChild(tuft)
        }
    }

    private static func addAntlers(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        for side: CGFloat in [-1, 1] {
            let path = CGMutablePath()
            let baseX = side * (halfW - 3)
            // Main branch going up
            path.move(to: CGPoint(x: baseX, y: halfH))
            path.addLine(to: CGPoint(x: baseX, y: halfH + 7))
            // Small branch forking out
            path.move(to: CGPoint(x: baseX, y: halfH + 4))
            path.addLine(to: CGPoint(x: baseX + side * 3, y: halfH + 6))

            let antler = SKShapeNode(path: path)
            antler.strokeColor = color
            antler.fillColor = .clear
            antler.lineWidth = 1.2
            antler.lineCap = .round
            parent.addChild(antler)
        }
    }

    // MARK: - Sanrio Accessories

    private static func addSanrioBow(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        // Hello Kitty's iconic bow on the right ear
        let bowX: CGFloat = halfW - 2
        let bowY: CGFloat = halfH + 4

        // Left loop
        let leftLoop = SKShapeNode(ellipseOf: CGSize(width: 5, height: 4))
        leftLoop.fillColor = color
        leftLoop.strokeColor = color.withAlphaComponent(0.7)
        leftLoop.lineWidth = 0.5
        leftLoop.position = CGPoint(x: bowX - 2.5, y: bowY)
        parent.addChild(leftLoop)

        // Right loop
        let rightLoop = SKShapeNode(ellipseOf: CGSize(width: 5, height: 4))
        rightLoop.fillColor = color
        rightLoop.strokeColor = color.withAlphaComponent(0.7)
        rightLoop.lineWidth = 0.5
        rightLoop.position = CGPoint(x: bowX + 2.5, y: bowY)
        parent.addChild(rightLoop)

        // Center knot
        let knot = SKShapeNode(circleOfRadius: 1.5)
        knot.fillColor = SKColor(hex: 0xFFD700)
        knot.strokeColor = .clear
        knot.lineWidth = 0
        knot.position = CGPoint(x: bowX, y: bowY)
        parent.addChild(knot)
    }

    private static func addSanrioHood(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        // My Melody's hood with floppy ears
        // Hood dome on top
        let hoodPath = CGMutablePath()
        hoodPath.addArc(center: CGPoint(x: 0, y: halfH), radius: halfW + 2, startAngle: 0, endAngle: .pi, clockwise: false)
        hoodPath.closeSubpath()
        let hood = SKShapeNode(path: hoodPath)
        hood.fillColor = color
        hood.strokeColor = color.withAlphaComponent(0.7)
        hood.lineWidth = 0.5
        parent.addChild(hood)

        // Floppy bunny ears on the hood
        for side: CGFloat in [-1, 1] {
            let earPath = CGMutablePath()
            let baseX = side * (halfW - 1)
            earPath.move(to: CGPoint(x: baseX - 2.5, y: halfH))
            earPath.addQuadCurve(
                to: CGPoint(x: baseX, y: halfH + 10),
                control: CGPoint(x: baseX - 2, y: halfH + 6)
            )
            earPath.addQuadCurve(
                to: CGPoint(x: baseX + 2.5, y: halfH),
                control: CGPoint(x: baseX + 2, y: halfH + 6)
            )
            earPath.closeSubpath()
            let ear = SKShapeNode(path: earPath)
            ear.fillColor = color
            ear.strokeColor = color.withAlphaComponent(0.7)
            ear.lineWidth = 0.5
            parent.addChild(ear)
        }
    }

    private static func addSanrioJester(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        // Kuromi's jester hat with skull
        for side: CGFloat in [-1, 1] {
            let path = CGMutablePath()
            let baseX = side * (halfW - 3)
            path.move(to: CGPoint(x: baseX - 3, y: halfH - 1))
            path.addQuadCurve(
                to: CGPoint(x: baseX + side * 4, y: halfH + 9),
                control: CGPoint(x: baseX, y: halfH + 7)
            )
            path.addLine(to: CGPoint(x: baseX + 3, y: halfH - 1))
            path.closeSubpath()
            let horn = SKShapeNode(path: path)
            horn.fillColor = SKColor(hex: 0x2D2D2D)
            horn.strokeColor = color.withAlphaComponent(0.7)
            horn.lineWidth = 0.5
            parent.addChild(horn)

            // Pink tip ball
            let tip = SKShapeNode(circleOfRadius: 1.5)
            tip.fillColor = color
            tip.strokeColor = .clear
            tip.lineWidth = 0
            tip.position = CGPoint(x: baseX + side * 4, y: halfH + 9)
            parent.addChild(tip)
        }

        // Small skull on forehead
        let skull = SKShapeNode(circleOfRadius: 2.0)
        skull.fillColor = .white
        skull.strokeColor = .clear
        skull.lineWidth = 0
        skull.position = CGPoint(x: 0, y: halfH + 2)
        parent.addChild(skull)

        // Skull eyes
        for side: CGFloat in [-1, 1] {
            let eye = SKShapeNode(circleOfRadius: 0.5)
            eye.fillColor = SKColor(hex: 0x2D2D2D)
            eye.strokeColor = .clear
            eye.lineWidth = 0
            eye.position = CGPoint(x: side * 0.8, y: halfH + 2.3)
            parent.addChild(eye)
        }
    }

    private static func addSanrioBeret(to parent: SKNode, halfW: CGFloat, halfH: CGFloat, color: SKColor) {
        // Pompompurin's beret
        let beretPath = CGMutablePath()
        beretPath.addEllipse(in: CGRect(x: -halfW - 1, y: halfH - 1, width: (halfW + 1) * 2, height: 5))
        let beret = SKShapeNode(path: beretPath)
        beret.fillColor = color
        beret.strokeColor = color.withAlphaComponent(0.7)
        beret.lineWidth = 0.5
        parent.addChild(beret)

        // Little stem on top
        let stem = SKShapeNode(circleOfRadius: 1.2)
        stem.fillColor = color
        stem.strokeColor = color.withAlphaComponent(0.7)
        stem.lineWidth = 0.5
        stem.position = CGPoint(x: 0, y: halfH + 4)
        parent.addChild(stem)
    }

    // MARK: - Mouth

    private static func createMouthNode(expression: CubeExpression, skin: AnimalSkin?) -> SKShapeNode {
        let path = CGMutablePath()
        let mouthY: CGFloat = -3.8

        switch expression {
        case .normal:
            // Kawaii cat mouth (w shape)
            path.move(to: CGPoint(x: -2.5, y: mouthY))
            path.addQuadCurve(to: CGPoint(x: 0, y: mouthY),
                              control: CGPoint(x: -1.2, y: mouthY - 1.5))
            path.addQuadCurve(to: CGPoint(x: 2.5, y: mouthY),
                              control: CGPoint(x: 1.2, y: mouthY - 1.5))

        case .happy:
            // Big smile with open mouth
            path.move(to: CGPoint(x: -3, y: mouthY + 0.5))
            path.addQuadCurve(to: CGPoint(x: 3, y: mouthY + 0.5),
                              control: CGPoint(x: 0, y: mouthY - 3))

        case .surprised:
            // Small O shape
            let ovalRect = CGRect(x: -1.8, y: mouthY - 1.8, width: 3.6, height: 3.6)
            path.addEllipse(in: ovalRect)

        case .sad:
            // Wobbly frown
            path.move(to: CGPoint(x: -2.5, y: mouthY - 1.5))
            path.addQuadCurve(to: CGPoint(x: 2.5, y: mouthY - 1.5),
                              control: CGPoint(x: 0, y: mouthY + 1))
        }

        let mouth = SKShapeNode(path: path)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = expression == .surprised ? SKColor(hex: 0x2D3436) : .clear
        mouth.lineWidth = 0.8
        return mouth
    }

    // MARK: - Helpers

    private static func darkenColor(_ color: SKColor) -> SKColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return SKColor(red: r * 0.7, green: g * 0.7, blue: b * 0.7, alpha: a)
    }

    private static func lightenColor(_ color: SKColor) -> SKColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return SKColor(red: min(1.0, r + (1.0 - r) * 0.4),
                       green: min(1.0, g + (1.0 - g) * 0.4),
                       blue: min(1.0, b + (1.0 - b) * 0.4),
                       alpha: a)
    }
}
