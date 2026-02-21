import SpriteKit

final class LevelGenerator {
    private let nodePool: NodePool
    private let level: Int
    private var rng: RandomNumberGenerator

    private var nextSpawnX: CGFloat = 0
    private var currentY: CGFloat = Constants.playerGroundY
    private var segmentIndex: Int = 0
    private var segments: [LevelSegment] = []

    init(nodePool: NodePool, level: Int, seed: UInt64? = nil) {
        self.nodePool = nodePool
        self.level = level
        if let seed = seed {
            self.rng = SeededRNG(seed: seed)
        } else {
            self.rng = SeededRNG(seed: UInt64(level) &* 6364136223846793005 &+ 1442695040888963407)
        }
        generateSegmentList()
    }

    private func generateSegmentList() {
        let difficulty = min(level, 50)
        let totalWidth = Constants.levelLength
        var usedWidth: CGFloat = 0

        // Always start with a flat run
        segments.append(LevelSegment.flatRun(y: currentY))
        usedWidth += 160

        while usedWidth < totalWidth - 200 {
            let segment = pickSegment(difficulty: difficulty)
            segments.append(segment)
            usedWidth += segment.width
        }

        // End with flat run leading to treasure
        segments.append(LevelSegment.flatRun(y: currentY))
    }

    private func pickSegment(difficulty: Int) -> LevelSegment {
        let available = availableSegmentTypes(for: difficulty)
        let typeIndex = Int.random(in: 0..<available.count, using: &rng)
        let segType = available[typeIndex]

        // Vary Y position a bit
        let yVariation = CGFloat.random(in: -15...15, using: &rng)
        currentY = max(25, min(120, currentY + yVariation))

        switch segType {
        case .flatRun: return LevelSegment.flatRun(y: currentY)
        case .stairUp: return LevelSegment.stairUp(startY: currentY)
        case .stairDown: return LevelSegment.stairDown(startY: currentY)
        case .gap: return LevelSegment.gap(y: currentY)
        case .movingBridge: return LevelSegment.movingBridge(y: currentY)
        case .spikeField: return LevelSegment.spikeField(y: currentY)
        case .quicksandPit: return LevelSegment.quicksandPit(y: currentY)
        case .knifeAlley: return LevelSegment.knifeAlley(y: currentY)
        case .timedPlatforms: return LevelSegment.timedPlatforms(y: currentY)
        case .mixedHazards: return LevelSegment.mixedHazards(y: currentY)
        }
    }

    private func availableSegmentTypes(for difficulty: Int) -> [SegmentType] {
        var types: [SegmentType] = [.flatRun, .stairUp, .stairDown, .gap]
        if difficulty >= 2 { types.append(.spikeField) }
        if difficulty >= 3 { types.append(.movingBridge) }
        if difficulty >= 4 { types.append(.knifeAlley) }
        if difficulty >= 5 { types.append(.quicksandPit) }
        if difficulty >= 10 { types.append(.mixedHazards) }
        return types
    }

    /// Spawns segments that are about to enter the visible area
    func spawnIfNeeded(cameraX: CGFloat, sceneWidth: CGFloat, parent: SKNode) {
        let spawnThreshold = cameraX + sceneWidth * 1.5

        while segmentIndex < segments.count && nextSpawnX < spawnThreshold {
            let segment = segments[segmentIndex]
            spawnSegment(segment, at: nextSpawnX, in: parent)
            nextSpawnX += segment.width
            segmentIndex += 1
        }
    }

    private func spawnSegment(_ segment: LevelSegment, at baseX: CGFloat, in parent: SKNode) {
        for piece in segment.pieces {

            let x = baseX + piece.offsetX
            let y = piece.offsetY

            switch piece.type {
            case .platform(let pType, let width):
                let platform = nodePool.getPlatform(type: pType, width: width)
                platform.position = CGPoint(x: x, y: y)
                platform.setMoveOrigin(platform.position)
                nodePool.activate(platform, in: parent)

            case .spike(let variant):
                let spike = nodePool.getSpike(variant: variant)
                spike.position = CGPoint(x: x, y: y)
                spike.setMoveOrigin(spike.position)
                nodePool.activate(spike, in: parent)

            case .quicksand(let width):
                let qs = nodePool.getQuicksand(width: width)
                qs.position = CGPoint(x: x, y: y)
                nodePool.activate(qs, in: parent)

            case .knife:
                let knife = nodePool.getKnife()
                knife.position = CGPoint(x: x, y: y)
                knife.showWarning()
                nodePool.activate(knife, in: parent)
            }
        }
    }

    /// Spawn the treasure chest at the end of the level
    func spawnTreasureIfNeeded(cameraX: CGFloat, sceneWidth: CGFloat, parent: SKNode) -> TreasureChestNode? {
        let treasureX = Constants.levelLength - 50
        let spawnThreshold = cameraX + sceneWidth

        if treasureX < spawnThreshold && parent.childNode(withName: "treasure") == nil {
            let treasure = TreasureChestNode()
            treasure.position = CGPoint(x: treasureX, y: currentY + 20)
            parent.addChild(treasure)
            return treasure
        }
        return nil
    }

    func reset() {
        segmentIndex = 0
        nextSpawnX = 0
        currentY = Constants.playerGroundY
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}
