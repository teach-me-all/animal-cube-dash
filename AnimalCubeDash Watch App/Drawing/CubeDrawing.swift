import SpriteKit

enum CubeExpression {
    case normal, happy, surprised, sad
}

struct CubeDrawing {

    // MARK: - Main Factory

    static func createCube(skin: AnimalSkin) -> SKNode {
        let parent = SKNode()
        parent.name = "cubeRoot"

        // Store skin so setExpression can access it
        parent.userData = NSMutableDictionary()
        parent.userData?["skin"] = skin.rawValue

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

        // Face: legendary Sanrio skins get character-specific faces
        if skin.rarity == .legendary {
            addSanrioFace(to: parent, skin: skin)
        } else {
            // Eyes (big kawaii eyes)
            addKawaiiEyes(to: parent, skin: skin)

            // Blush circles on cheeks
            addBlush(to: parent)

            // Mouth (default normal - cute cat mouth)
            let mouth = createMouthNode(expression: .normal, skin: skin)
            mouth.name = "mouth"
            parent.addChild(mouth)
        }

        // Small nose
        addNose(to: parent, skin: skin)

        return parent
    }

    // MARK: - Expression

    static func setExpression(_ node: SKNode, expression: CubeExpression) {
        // Hello Kitty, My Melody, and Pochacco have no mouth
        if let skinRaw = node.userData?["skin"] as? String,
           let skin = AnimalSkin(rawValue: skinRaw),
           skin == .helloKitty || skin == .myMelody || skin == .pochacco {
            return
        }
        node.childNode(withName: "mouth")?.removeFromParent()
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
            // Yellow oval nose (same as Hello Kitty)
            let nose = SKShapeNode(ellipseOf: CGSize(width: 1.8, height: 1.2))
            nose.fillColor = SKColor(hex: 0xFFD700)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .cinnamoroll:
            break // Cinnamoroll has no nose

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
            break // Keroppi has no visible nose

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

        case .brownBear:
            // Round brown nose
            let nose = SKShapeNode(circleOfRadius: 1.0)
            nose.fillColor = SKColor(hex: 0x3E2010)
            nose.strokeColor = .clear
            nose.lineWidth = 0
            nose.position = CGPoint(x: 0, y: noseY)
            parent.addChild(nose)

        case .polarBear:
            // Round dark nose
            let nose = SKShapeNode(circleOfRadius: 1.0)
            nose.fillColor = SKColor(hex: 0x2D3436)
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

    // MARK: - Sanrio Faces

    private static func addSanrioFace(to parent: SKNode, skin: AnimalSkin) {
        switch skin {
        case .helloKitty:      addHelloKittyFace(to: parent)
        case .myMelody:        addMyMelodyFace(to: parent)
        case .cinnamoroll:     addCinnamorollFace(to: parent)
        case .kuromi:          addKuromiFace(to: parent)
        case .pompompurin:     addPompompurinFace(to: parent)
        case .keroppi:         addKeroppiiFace(to: parent)
        case .pochacco:        addPochaccoFace(to: parent)
        case .badtzMaru:       addBadtzMaruFace(to: parent)
        case .tuxedoSam:       addTuxedoSamFace(to: parent)
        case .littleTwinStars: addTwinStarFace(to: parent, starColor: SKColor(hex: 0xF48FB1))
        case .blueTwinStar:    addTwinStarFace(to: parent, starColor: SKColor(hex: 0x42A5F5))
        default:
            addKawaiiEyes(to: parent, skin: skin)
            addBlush(to: parent)
            let mouth = createMouthNode(expression: .normal, skin: skin)
            mouth.name = "mouth"
            parent.addChild(mouth)
        }
    }

    /// Hello Kitty — small horizontal oval eyes, whiskers, no mouth
    private static func addHelloKittyFace(to parent: SKNode) {
        // Eyes: small horizontal ovals (wider than tall), set close together
        for side: CGFloat in [-1, 1] {
            let eye = SKShapeNode(ellipseOf: CGSize(width: 3.2, height: 2.0))
            eye.fillColor = SKColor(hex: 0x2D3436)
            eye.strokeColor = .clear
            eye.lineWidth = 0
            eye.position = CGPoint(x: side * 3.0, y: 1.8)
            parent.addChild(eye)
        }
        // 3 whiskers per side (6 total) — Hello Kitty's most iconic feature
        for side: CGFloat in [-1, 1] {
            for (i, yOffset) in ([0.8, -0.5, -1.8] as [CGFloat]).enumerated() {
                let whiskerPath = CGMutablePath()
                let startX = side * 4.0
                let endX = side * 8.0
                whiskerPath.move(to: CGPoint(x: startX, y: yOffset))
                whiskerPath.addLine(to: CGPoint(x: endX, y: yOffset + CGFloat(i) * 0.1))
                let whisker = SKShapeNode(path: whiskerPath)
                whisker.strokeColor = SKColor(hex: 0x636E72)
                whisker.lineWidth = 0.4
                whisker.lineCap = .round
                parent.addChild(whisker)
            }
        }
        addBlush(to: parent)
        // No mouth — intentional (Hello Kitty has no mouth)
    }

    /// My Melody — tiny solid dot eyes (no whites), no mouth (yellow nose from addNose)
    private static func addMyMelodyFace(to parent: SKNode) {
        // Very small dot eyes, set wide apart — My Melody's simple dot-eye style
        for side: CGFloat in [-1, 1] {
            let eye = SKShapeNode(ellipseOf: CGSize(width: 2.8, height: 2.8))
            eye.fillColor = SKColor(hex: 0x2D3436)
            eye.strokeColor = .clear
            eye.lineWidth = 0
            eye.position = CGPoint(x: side * 3.5, y: 1.5)
            parent.addChild(eye)
        }
        addBlush(to: parent)
        // No mouth — My Melody has an absent/minimal mouth like Hello Kitty
    }

    /// Cinnamoroll — huge sky-blue eyes, no nose, W-shaped cat mouth, cinnamon swirl on head
    private static func addCinnamorollFace(to parent: SKNode) {
        for side: CGFloat in [-1, 1] {
            let white = SKShapeNode(circleOfRadius: 3.6)
            white.fillColor = .white
            white.strokeColor = SKColor(white: 0.85, alpha: 1)
            white.lineWidth = 0.5
            white.position = CGPoint(x: side * 3.3, y: 1.8)
            parent.addChild(white)

            // Sky-blue iris (Cinnamoroll's characteristic light-blue eyes)
            let iris = SKShapeNode(circleOfRadius: 2.5)
            iris.fillColor = SKColor(hex: 0x64B5F6) // sky blue
            iris.strokeColor = .clear
            iris.lineWidth = 0
            iris.position = CGPoint(x: 0, y: -0.3)
            white.addChild(iris)

            let pupil = SKShapeNode(circleOfRadius: 1.3)
            pupil.fillColor = SKColor(hex: 0x1565C0) // deeper blue pupil
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            pupil.position = .zero
            iris.addChild(pupil)

            let sparkle = SKShapeNode(circleOfRadius: 0.55)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: 0.5, y: 0.5)
            pupil.addChild(sparkle)
        }
        // Chubby pink cheeks
        for side: CGFloat in [-1, 1] {
            let blush = SKShapeNode(ellipseOf: CGSize(width: 3.5, height: 2.2))
            blush.fillColor = SKColor(red: 1.0, green: 0.65, blue: 0.75, alpha: 0.5)
            blush.strokeColor = .clear
            blush.lineWidth = 0
            blush.position = CGPoint(x: side * 5.5, y: -1.5)
            parent.addChild(blush)
        }
        // W-shaped cat mouth (subtle)
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -1.8, y: -4.2))
        mouthPath.addQuadCurve(to: CGPoint(x: 0, y: -4.2), control: CGPoint(x: -0.9, y: -5.3))
        mouthPath.addQuadCurve(to: CGPoint(x: 1.8, y: -4.2), control: CGPoint(x: 0.9, y: -5.3))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 0.8
        mouth.name = "mouth"
        parent.addChild(mouth)
        // Pink cinnamon swirl on top of head (signature mark)
        let curlPath = CGMutablePath()
        curlPath.addArc(center: CGPoint(x: 0.5, y: 7.8),
                        radius: 1.8,
                        startAngle: .pi * 1.15, endAngle: .pi * 0.1,
                        clockwise: true)
        let curl = SKShapeNode(path: curlPath)
        curl.strokeColor = SKColor(hex: 0xFFB6C1)
        curl.fillColor = .clear
        curl.lineWidth = 1.6
        curl.lineCap = .round
        parent.addChild(curl)
    }

    /// Kuromi — white face oval on dark body, purple eyes, angled brows, smirk with fang
    private static func addKuromiFace(to parent: SKNode) {
        // White face oval patch (Kuromi's most distinctive feature — pale face on dark body)
        let faceOval = SKShapeNode(ellipseOf: CGSize(width: 13.0, height: 12.0))
        faceOval.fillColor = .white
        faceOval.strokeColor = SKColor(white: 0.85, alpha: 1)
        faceOval.lineWidth = 0.4
        faceOval.position = CGPoint(x: 0, y: -0.5)
        parent.addChild(faceOval)

        for side: CGFloat in [-1, 1] {
            let white = SKShapeNode(circleOfRadius: 3.0)
            white.fillColor = .white
            white.strokeColor = SKColor(white: 0.8, alpha: 1)
            white.lineWidth = 0.4
            white.position = CGPoint(x: side * 3.8, y: 1.5)
            parent.addChild(white)

            let pupil = SKShapeNode(circleOfRadius: 2.0)
            pupil.fillColor = SKColor(hex: 0x7B1FA2) // deep purple
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            pupil.position = CGPoint(x: side * 0.3, y: -0.2)
            white.addChild(pupil)

            let sparkle = SKShapeNode(circleOfRadius: 0.65)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: 0.4, y: 0.5)
            pupil.addChild(sparkle)

            // Angled brow: inner end lower, outer end higher — Kuromi's furrowed look
            let bx = side * 3.8
            let browPath = CGMutablePath()
            browPath.move(to: CGPoint(x: bx - side * 2.8, y: 4.2))
            browPath.addLine(to: CGPoint(x: bx + side * 2.2, y: 5.5))
            let brow = SKShapeNode(path: browPath)
            brow.strokeColor = SKColor(hex: 0x1A1A1A)
            brow.lineWidth = 1.4
            brow.lineCap = .round
            parent.addChild(brow)
        }
        // Smirk mouth
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -2.2, y: -4.0))
        mouthPath.addQuadCurve(to: CGPoint(x: 2.0, y: -3.4), control: CGPoint(x: 0.5, y: -5.6))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 0.9
        mouth.name = "mouth"
        parent.addChild(mouth)
        // Small white fang (Kuromi's signature pointy tooth)
        let fangPath = CGMutablePath()
        fangPath.move(to: CGPoint(x: -0.6, y: -4.2))
        fangPath.addLine(to: CGPoint(x: -1.8, y: -5.6))
        fangPath.addLine(to: CGPoint(x: 0.3, y: -4.8))
        fangPath.closeSubpath()
        let fang = SKShapeNode(path: fangPath)
        fang.fillColor = .white
        fang.strokeColor = SKColor(white: 0.7, alpha: 1)
        fang.lineWidth = 0.3
        parent.addChild(fang)
    }

    /// Pompompurin — small downward-arc closed eyes (sleepy/relaxed), content smile
    private static func addPompompurinFace(to parent: SKNode) {
        // Pompompurin's eyes are NOT open ovals — they're tiny downward arc lines (closed/sleepy)
        for side: CGFloat in [-1, 1] {
            let ex = side * 3.2
            // Downward arc: endpoints higher than midpoint — a gentle closed-eye look
            let eyePath = CGMutablePath()
            eyePath.move(to: CGPoint(x: ex - 2.2, y: 2.2))
            eyePath.addQuadCurve(to: CGPoint(x: ex + 2.2, y: 2.2),
                                 control: CGPoint(x: ex, y: 0.5))
            let eye = SKShapeNode(path: eyePath)
            eye.strokeColor = SKColor(hex: 0x5D4037) // warm brown
            eye.fillColor = .clear
            eye.lineWidth = 1.5
            eye.lineCap = .round
            parent.addChild(eye)
        }
        addBlush(to: parent)
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -2.5, y: -3.8))
        mouthPath.addQuadCurve(to: CGPoint(x: 2.5, y: -3.8), control: CGPoint(x: 0, y: -5.4))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 0.8
        mouth.name = "mouth"
        parent.addChild(mouth)
    }

    /// Keroppi — huge round eyes (pupils at top, white crescent at bottom), V-shaped mouth
    private static func addKeroppiiFace(to parent: SKNode) {
        for side: CGFloat in [-1, 1] {
            let white = SKShapeNode(circleOfRadius: 4.0)
            white.fillColor = .white
            white.strokeColor = SKColor(white: 0.85, alpha: 1)
            white.lineWidth = 0.6
            white.position = CGPoint(x: side * 3.0, y: 2.5)
            parent.addChild(white)

            let pupil = SKShapeNode(circleOfRadius: 2.5)
            pupil.fillColor = SKColor(hex: 0x2D3436)
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            // Pupils sit HIGH — leaving white crescent visible at bottom (Keroppi's look)
            pupil.position = CGPoint(x: side * 0.3, y: 0.9)
            white.addChild(pupil)

            let sparkle = SKShapeNode(circleOfRadius: 0.9)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: 0.6, y: 0.7)
            pupil.addChild(sparkle)
        }
        // Keroppi's V-shaped mouth: two diagonal lines meeting at a bottom-center point
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -3.5, y: -2.8))
        mouthPath.addLine(to: CGPoint(x: 0, y: -5.2))
        mouthPath.addLine(to: CGPoint(x: 3.5, y: -2.8))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 1.0
        mouth.lineCap = .round
        mouth.lineJoin = .round
        mouth.name = "mouth"
        parent.addChild(mouth)
    }

    /// Pochacco — small dot eyes, ink spot on forehead, NO mouth (like Hello Kitty)
    private static func addPochaccoFace(to parent: SKNode) {
        for side: CGFloat in [-1, 1] {
            let eye = SKShapeNode(circleOfRadius: 1.8)
            eye.fillColor = SKColor(hex: 0x2D3436)
            eye.strokeColor = .clear
            eye.lineWidth = 0
            eye.position = CGPoint(x: side * 3.2, y: 1.5)
            parent.addChild(eye)

            let sparkle = SKShapeNode(circleOfRadius: 0.55)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: side * 0.5, y: 0.6)
            eye.addChild(sparkle)
        }
        addBlush(to: parent)
        // Pochacco's signature ink spot on top of head
        let spot = SKShapeNode(circleOfRadius: 2.0)
        spot.fillColor = SKColor(hex: 0x2D3436)
        spot.strokeColor = .clear
        spot.lineWidth = 0
        spot.position = CGPoint(x: 0.5, y: 5.5)
        parent.addChild(spot)
        // No mouth — Pochacco has no mouth like Hello Kitty
    }

    /// Badtz-Maru — white belly oval, 4 spiky hair, half-lidded pupils at top, grumpy frown
    private static func addBadtzMaruFace(to parent: SKNode) {
        // White belly/chest oval (his distinctive white belly patch)
        let belly = SKShapeNode(ellipseOf: CGSize(width: 10.0, height: 9.0))
        belly.fillColor = .white
        belly.strokeColor = SKColor(white: 0.85, alpha: 1)
        belly.lineWidth = 0.4
        belly.position = CGPoint(x: 0, y: -1.5)
        parent.addChild(belly)

        for side: CGFloat in [-1, 1] {
            let white = SKShapeNode(ellipseOf: CGSize(width: 5.5, height: 5.5))
            white.fillColor = .white
            white.strokeColor = SKColor(white: 0.6, alpha: 1)
            white.lineWidth = 0.5
            white.position = CGPoint(x: side * 3.5, y: 1.5)
            parent.addChild(white)

            let pupil = SKShapeNode(circleOfRadius: 2.2)
            pupil.fillColor = SKColor(hex: 0x2D3436)
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            // Pupils at TOP of whites — half-lidded mean expression
            pupil.position = CGPoint(x: side * 0.3, y: 1.0)
            white.addChild(pupil)

            let sparkle = SKShapeNode(circleOfRadius: 0.65)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: 0.4, y: 0.5)
            pupil.addChild(sparkle)

            // Heavy angry brow: inner corner high, outer corner low
            let bx = side * 3.5
            let browPath = CGMutablePath()
            browPath.move(to: CGPoint(x: bx - side * 2.5, y: 6.5))
            browPath.addLine(to: CGPoint(x: bx + side * 3.0, y: 4.8))
            let brow = SKShapeNode(path: browPath)
            brow.strokeColor = SKColor(hex: 0x1A1A1A)
            brow.lineWidth = 1.8
            brow.lineCap = .round
            parent.addChild(brow)
        }
        // 4 spiky black hair on top of head
        for (hx, htop): (CGFloat, CGFloat) in [(-5.0, 8.5), (-1.8, 10.5), (1.5, 9.5), (4.5, 8.0)] {
            let hairPath = CGMutablePath()
            hairPath.move(to: CGPoint(x: hx - 1.5, y: htop - 3.5))
            hairPath.addLine(to: CGPoint(x: hx, y: htop))
            hairPath.addLine(to: CGPoint(x: hx + 1.5, y: htop - 3.5))
            hairPath.closeSubpath()
            let hair = SKShapeNode(path: hairPath)
            hair.fillColor = SKColor(hex: 0x1A1A1A)
            hair.strokeColor = .clear
            hair.lineWidth = 0
            parent.addChild(hair)
        }
        // Grumpy frown (upward-arcing curve = downward mouth expression)
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -2.5, y: -4.5))
        mouthPath.addQuadCurve(to: CGPoint(x: 2.5, y: -4.5), control: CGPoint(x: 0, y: -2.8))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 1.0
        mouth.name = "mouth"
        parent.addChild(mouth)
    }

    /// Tuxedo Sam — white belly patch, round eyes, RED bow tie on chest, happy smile
    private static func addTuxedoSamFace(to parent: SKNode) {
        // White belly/chest oval (Tuxedo Sam's penguin belly)
        let belly = SKShapeNode(ellipseOf: CGSize(width: 10.0, height: 9.0))
        belly.fillColor = .white
        belly.strokeColor = SKColor(white: 0.85, alpha: 1)
        belly.lineWidth = 0.4
        belly.position = CGPoint(x: 0, y: -1.5)
        parent.addChild(belly)

        for side: CGFloat in [-1, 1] {
            let white = SKShapeNode(circleOfRadius: 3.2)
            white.fillColor = .white
            white.strokeColor = SKColor(white: 0.8, alpha: 1)
            white.lineWidth = 0.4
            white.position = CGPoint(x: side * 3.5, y: 2.0)
            parent.addChild(white)

            let pupil = SKShapeNode(circleOfRadius: 2.0)
            pupil.fillColor = SKColor(hex: 0x2D3436)
            pupil.strokeColor = .clear
            pupil.lineWidth = 0
            pupil.position = CGPoint(x: side * 0.3, y: -0.2)
            white.addChild(pupil)

            let sparkle = SKShapeNode(circleOfRadius: 0.7)
            sparkle.fillColor = .white
            sparkle.strokeColor = .clear
            sparkle.position = CGPoint(x: 0.5, y: 0.6)
            pupil.addChild(sparkle)
        }
        addBlush(to: parent)
        // RED bow tie on chest (Tuxedo Sam's most distinctive feature — it is RED, not blue)
        for side: CGFloat in [-1, 1] {
            let loop = SKShapeNode(ellipseOf: CGSize(width: 3.5, height: 2.5))
            loop.fillColor = SKColor(hex: 0xE53935)
            loop.strokeColor = SKColor(hex: 0xC62828)
            loop.lineWidth = 0.4
            loop.position = CGPoint(x: side * 2.2, y: -5.0)
            parent.addChild(loop)
        }
        let knot = SKShapeNode(circleOfRadius: 1.2)
        knot.fillColor = SKColor(hex: 0xE53935)
        knot.strokeColor = .clear
        knot.lineWidth = 0
        knot.position = CGPoint(x: 0, y: -5.0)
        parent.addChild(knot)

        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -2.5, y: -3.2))
        mouthPath.addQuadCurve(to: CGPoint(x: 2.5, y: -3.2), control: CGPoint(x: 0, y: -5.0))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 0.8
        mouth.name = "mouth"
        parent.addChild(mouth)
    }

    /// LittleTwinStars (Lala=pink hair) / BlueTwinStar (Kiki=blue hair) — star eyes, bright smile
    private static func addTwinStarFace(to parent: SKNode, starColor: SKColor) {
        // Hair on top of cube (Lala = long pink, Kiki = blue bowl cut — represented as hair blobs)
        let hairOffsets: [(CGFloat, CGFloat)] = [(-5.5, 7.5), (-2.5, 9.0), (0.5, 9.5), (3.5, 8.5)]
        for (hx, hy) in hairOffsets {
            let strand = SKShapeNode(ellipseOf: CGSize(width: 4.5, height: 4.0))
            strand.fillColor = starColor
            strand.strokeColor = .clear
            strand.lineWidth = 0
            strand.position = CGPoint(x: hx, y: hy)
            parent.addChild(strand)
        }

        let outerR: CGFloat = 2.8
        let innerR: CGFloat = 1.1
        let numPoints = 5
        let angleStep = CGFloat.pi / CGFloat(numPoints)

        for side: CGFloat in [-1, 1] {
            let cx: CGFloat = side * 3.5
            let cy: CGFloat = 1.8
            let starPath = CGMutablePath()
            for i in 0..<numPoints * 2 {
                let r = (i % 2 == 0) ? outerR : innerR
                let angle = CGFloat(i) * angleStep - .pi / 2
                let px = cx + r * cos(angle)
                let py = cy + r * sin(angle)
                if i == 0 { starPath.move(to: CGPoint(x: px, y: py)) }
                else { starPath.addLine(to: CGPoint(x: px, y: py)) }
            }
            starPath.closeSubpath()
            let star = SKShapeNode(path: starPath)
            star.fillColor = starColor
            star.strokeColor = starColor.withAlphaComponent(0.7)
            star.lineWidth = 0.4
            parent.addChild(star)

            // Tiny white sparkle at star centre
            let centre = SKShapeNode(circleOfRadius: 0.65)
            centre.fillColor = .white
            centre.strokeColor = .clear
            centre.position = CGPoint(x: cx, y: cy)
            parent.addChild(centre)
        }
        addBlush(to: parent)
        let mouthPath = CGMutablePath()
        mouthPath.move(to: CGPoint(x: -2.8, y: -3.8))
        mouthPath.addQuadCurve(to: CGPoint(x: 2.8, y: -3.8), control: CGPoint(x: 0, y: -5.8))
        let mouth = SKShapeNode(path: mouthPath)
        mouth.strokeColor = SKColor(hex: 0x2D3436)
        mouth.fillColor = .clear
        mouth.lineWidth = 0.8
        mouth.name = "mouth"
        parent.addChild(mouth)
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
