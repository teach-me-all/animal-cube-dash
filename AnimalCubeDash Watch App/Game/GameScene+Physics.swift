import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = sortBodies(contact)

        // Player + Platform
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.platform {
            handlePlayerLandOnPlatform(playerBody: bodyA, platformBody: bodyB)
            return
        }

        // Player + Spike
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.spike {
            loseLife()
            return
        }

        // Player + Knife
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.knife {
            if let knifeNode = bodyB.node {
                lastHitKnifeX = knifeNode.position.x
            }
            loseLife()
            return
        }

        // Player + Quicksand
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.quicksand {
            player.enterQuicksand()
            quicksandTimer.startTimer(for: player)
            return
        }

        // Player + Treasure
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.treasure {
            if let treasure = bodyB.node as? TreasureChestNode {
                treasure.playOpenAnimation { [weak self] in
                    guard let self = self else { return }
                    self.stateMachine.enter(.levelComplete)
                }
            }
            return
        }

        // Player + Bottom boundary — handled by position check in update() instead
        // to avoid double life loss
    }

    func didEnd(_ contact: SKPhysicsContact) {
        let (bodyA, bodyB) = sortBodies(contact)

        // Player left platform
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.platform {
            // Small delay before setting not grounded (to allow jump registration)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
                guard let self = self else { return }
                if let velocity = self.player.physicsBody?.velocity, velocity.dy < -1 {
                    self.player.setGrounded(false)
                }
            }
        }

        // Player left quicksand
        if bodyA.categoryBitMask == PhysicsCategory.player && bodyB.categoryBitMask == PhysicsCategory.quicksand {
            quicksandTimer.stopTimer()
        }
    }

    private func handlePlayerLandOnPlatform(playerBody: SKPhysicsBody, platformBody: SKPhysicsBody) {
        // Only land if player is falling onto the platform (coming from above)
        guard let playerVelocity = player.physicsBody?.velocity, playerVelocity.dy <= 1.0 else { return }

        let playerBottom = player.position.y - Constants.playerSize.height / 2
        let platformTop = (platformBody.node?.position.y ?? 0) + Constants.platformHeight / 2

        if playerBottom >= platformTop - 8 {
            player.land()
            player.markSafePosition()
        }
    }

    private func sortBodies(_ contact: SKPhysicsContact) -> (SKPhysicsBody, SKPhysicsBody) {
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            return (contact.bodyA, contact.bodyB)
        }
        return (contact.bodyB, contact.bodyA)
    }

}
