import CoreGraphics

enum SegmentType: Int, CaseIterable {
    case flatRun = 0
    case stairUp = 1
    case stairDown = 2
    case gap = 3
    case movingBridge = 4
    case spikeField = 5
    case quicksandPit = 6
    case knifeAlley = 7
    case timedPlatforms = 8
    case mixedHazards = 9
}

struct SegmentPiece {
    enum PieceType {
        case platform(PlatformType, CGFloat) // type, width
        case spike(SpikeVariant)
        case quicksand(CGFloat) // width
        case knife
    }

    let type: PieceType
    let offsetX: CGFloat
    let offsetY: CGFloat
}

struct LevelSegment {
    let segmentType: SegmentType
    let width: CGFloat
    let pieces: [SegmentPiece]

    static func flatRun(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 48), offsetX: 24, offsetY: y),
            SegmentPiece(type: .platform(.static_, 40), offsetX: 55, offsetY: y),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 130, offsetY: y)
        ]
        return LevelSegment(segmentType: .flatRun, width: 160, pieces: pieces)
    }

    static func stairUp(startY: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 32), offsetX: 20, offsetY: startY),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 60, offsetY: startY + 20),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 100, offsetY: startY + 40),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 145, offsetY: startY + 55)
        ]
        return LevelSegment(segmentType: .stairUp, width: 170, pieces: pieces)
    }

    static func stairDown(startY: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 32), offsetX: 20, offsetY: startY),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 60, offsetY: startY - 20),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 100, offsetY: startY - 35),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 140, offsetY: startY - 45)
        ]
        return LevelSegment(segmentType: .stairDown, width: 160, pieces: pieces)
    }

    static func gap(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 36), offsetX: 18, offsetY: y),
            // gap of ~50 pts requiring a jump
            SegmentPiece(type: .platform(.static_, 36), offsetX: 100, offsetY: y)
        ]
        return LevelSegment(segmentType: .gap, width: 130, pieces: pieces)
    }

    static func movingBridge(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 28), offsetX: 14, offsetY: y),
            SegmentPiece(type: .platform(.movingH, 28), offsetX: 60, offsetY: y),
            SegmentPiece(type: .platform(.movingH, 28), offsetX: 110, offsetY: y + 10),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 160, offsetY: y)
        ]
        return LevelSegment(segmentType: .movingBridge, width: 180, pieces: pieces)
    }

    static func spikeField(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 48), offsetX: 24, offsetY: y),
            SegmentPiece(type: .spike(.static_), offsetX: 50, offsetY: y + Constants.platformHeight / 2 + Constants.spikeHeight / 2),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 90, offsetY: y),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 140, offsetY: y + 15)
        ]
        return LevelSegment(segmentType: .spikeField, width: 160, pieces: pieces)
    }

    static func quicksandPit(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 28), offsetX: 14, offsetY: y),
            SegmentPiece(type: .quicksand(40), offsetX: 55, offsetY: y - 4),
            SegmentPiece(type: .platform(.static_, 28), offsetX: 100, offsetY: y),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 145, offsetY: y)
        ]
        return LevelSegment(segmentType: .quicksandPit, width: 170, pieces: pieces)
    }

    static func knifeAlley(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 32), offsetX: 16, offsetY: y),
            SegmentPiece(type: .knife, offsetX: 60, offsetY: y + 35),
            SegmentPiece(type: .platform(.static_, 36), offsetX: 90, offsetY: y),
            SegmentPiece(type: .platform(.static_, 32), offsetX: 140, offsetY: y + 15)
        ]
        return LevelSegment(segmentType: .knifeAlley, width: 160, pieces: pieces)
    }

    static func timedPlatforms(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 28), offsetX: 14, offsetY: y),
            SegmentPiece(type: .platform(.timed, 28), offsetX: 55, offsetY: y + 10),
            SegmentPiece(type: .platform(.timed, 28), offsetX: 95, offsetY: y),
            SegmentPiece(type: .platform(.static_, 32), offsetX: 140, offsetY: y + 5)
        ]
        return LevelSegment(segmentType: .timedPlatforms, width: 160, pieces: pieces)
    }

    static func mixedHazards(y: CGFloat) -> LevelSegment {
        let pieces = [
            SegmentPiece(type: .platform(.static_, 28), offsetX: 14, offsetY: y),
            SegmentPiece(type: .spike(.popup), offsetX: 40, offsetY: y + Constants.platformHeight / 2 + Constants.spikeHeight / 2),
            SegmentPiece(type: .platform(.movingV, 28), offsetX: 70, offsetY: y + 15),
            SegmentPiece(type: .knife, offsetX: 100, offsetY: y + 40),
            SegmentPiece(type: .platform(.static_, 32), offsetX: 140, offsetY: y)
        ]
        return LevelSegment(segmentType: .mixedHazards, width: 160, pieces: pieces)
    }
}
