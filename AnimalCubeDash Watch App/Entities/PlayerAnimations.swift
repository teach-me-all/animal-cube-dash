import SpriteKit

enum PlayerAnimationHelper {
    static func confettiEffect(at position: CGPoint, in parent: SKNode) {
        let colors: [SKColor] = [.red, .yellow, .green, .cyan, .orange, .magenta]
        for _ in 0..<12 {
            let piece = SKShapeNode(rectOf: CGSize(width: 3, height: 3))
            piece.fillColor = colors.randomElement() ?? .yellow
            piece.strokeColor = .clear
            piece.position = position
            parent.addChild(piece)

            let dx = CGFloat.random(in: -40...40)
            let dy = CGFloat.random(in: 20...60)
            let move = SKAction.moveBy(x: dx, y: dy, duration: 0.6)
            let fall = SKAction.moveBy(x: dx * 0.3, y: -80, duration: 0.4)
            let fade = SKAction.fadeOut(withDuration: 0.3)
            let spin = SKAction.rotate(byAngle: .pi * CGFloat.random(in: 1...4), duration: 1.0)
            let sequence = SKAction.sequence([move, SKAction.group([fall, fade])])
            piece.run(SKAction.group([sequence, spin, SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()])]))
        }
    }

    static func skinUnlockEffect(at position: CGPoint, in parent: SKNode) {
        // Ring expand
        let ring = SKShapeNode(circleOfRadius: 5)
        ring.strokeColor = .yellow
        ring.fillColor = .clear
        ring.lineWidth = 2
        ring.position = position
        parent.addChild(ring)

        let expand = SKAction.scale(to: 6.0, duration: 0.5)
        let fade = SKAction.fadeOut(withDuration: 0.5)
        ring.run(SKAction.sequence([SKAction.group([expand, fade]), SKAction.removeFromParent()]))

        // Mini confetti
        confettiEffect(at: position, in: parent)
    }

    static func deathPoof(at position: CGPoint, in parent: SKNode) {
        // Friendly poof cloud
        for i in 0..<6 {
            let angle = CGFloat(i) / 6.0 * .pi * 2
            let cloud = SKShapeNode(circleOfRadius: 4)
            cloud.fillColor = SKColor.white.withAlphaComponent(0.8)
            cloud.strokeColor = .clear
            cloud.position = position
            parent.addChild(cloud)

            let dx = cos(angle) * 15
            let dy = sin(angle) * 15
            let move = SKAction.moveBy(x: dx, y: dy, duration: 0.3)
            let fade = SKAction.fadeOut(withDuration: 0.3)
            let grow = SKAction.scale(to: 2.0, duration: 0.3)
            cloud.run(SKAction.sequence([SKAction.group([move, fade, grow]), SKAction.removeFromParent()]))
        }
    }
}
