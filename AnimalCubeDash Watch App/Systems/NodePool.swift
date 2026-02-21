import SpriteKit

final class NodePool {
    private var platformPool: [PlatformNode] = []
    private var spikePool: [SpikeNode] = []
    private var quicksandPool: [QuicksandNode] = []
    private var knifePool: [FlyingKnifeNode] = []

    private(set) var activeNodes: [SKNode] = []

    var activeCount: Int { activeNodes.count }

    func getPlatform(type: PlatformType, width: CGFloat) -> PlatformNode {
        if let recycled = platformPool.popLast() {
            recycled.reset()
            return recycled
        }
        return PlatformNode(type: type, width: width)
    }

    func getSpike(variant: SpikeVariant) -> SpikeNode {
        if let recycled = spikePool.popLast() {
            recycled.reset()
            return recycled
        }
        return SpikeNode(variant: variant)
    }

    func getQuicksand(width: CGFloat) -> QuicksandNode {
        if let recycled = quicksandPool.popLast() {
            return recycled
        }
        return QuicksandNode(width: width)
    }

    func getKnife(direction: CGVector = CGVector(dx: -1, dy: 0)) -> FlyingKnifeNode {
        if let recycled = knifePool.popLast() {
            return recycled
        }
        return FlyingKnifeNode(direction: direction)
    }

    func activate(_ node: SKNode, in parent: SKNode) {
        activeNodes.append(node)
        parent.addChild(node)
    }

    func deactivate(_ node: SKNode) {
        node.removeFromParent()
        activeNodes.removeAll { $0 === node }

        if let platform = node as? PlatformNode {
            platformPool.append(platform)
        } else if let spike = node as? SpikeNode {
            spikePool.append(spike)
        } else if let quicksand = node as? QuicksandNode {
            quicksandPool.append(quicksand)
        } else if let knife = node as? FlyingKnifeNode {
            knifePool.append(knife)
        }
    }

    func deactivateAll() {
        for node in activeNodes {
            node.removeFromParent()
            if let platform = node as? PlatformNode {
                platformPool.append(platform)
            } else if let spike = node as? SpikeNode {
                spikePool.append(spike)
            } else if let quicksand = node as? QuicksandNode {
                quicksandPool.append(quicksand)
            } else if let knife = node as? FlyingKnifeNode {
                knifePool.append(knife)
            }
        }
        activeNodes.removeAll()
    }

    func cullOffscreen(camera: SKCameraNode?, sceneSize: CGSize) {
        let toRemove = activeNodes.filter { !$0.isOnScreen(camera: camera, sceneSize: sceneSize) }
        for node in toRemove {
            deactivate(node)
        }
    }
}
