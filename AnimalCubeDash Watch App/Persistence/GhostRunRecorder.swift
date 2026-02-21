import Foundation
import CoreGraphics

struct GhostRunData: Codable {
    let level: Int
    let skin: String
    let positions: [[Double]] // Array of [x, y] pairs
    let timestamps: [TimeInterval]
    let totalTime: TimeInterval
}

final class GhostRunRecorder {

    private(set) var frames: [(position: CGPoint, timeStamp: TimeInterval)] = []
    private(set) var isRecording = false

    private var level: Int = 0
    private var skin: AnimalSkin = .cat
    private var startTime: TimeInterval = 0

    func startRecording(level: Int, skin: AnimalSkin) {
        self.level = level
        self.skin = skin
        self.startTime = 0
        frames = []
        isRecording = true
    }

    func recordFrame(position: CGPoint, time: TimeInterval) {
        guard isRecording else { return }

        if frames.isEmpty {
            startTime = time
        }

        let relativeTime = time - startTime
        frames.append((position: position, timeStamp: relativeTime))
    }

    func stopRecording() -> GhostRunData {
        isRecording = false

        let positions = frames.map { [Double($0.position.x), Double($0.position.y)] }
        let timestamps = frames.map { $0.timeStamp }
        let totalTime = timestamps.last ?? 0

        return GhostRunData(
            level: level,
            skin: skin.rawValue,
            positions: positions,
            timestamps: timestamps,
            totalTime: totalTime
        )
    }

    // MARK: - Persistence

    static func save(_ data: GhostRunData) {
        let key = "ghostRun_level_\(data.level)"
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    static func load(level: Int) -> GhostRunData? {
        let key = "ghostRun_level_\(level)"
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(GhostRunData.self, from: data)
    }

    static func delete(level: Int) {
        let key = "ghostRun_level_\(level)"
        UserDefaults.standard.removeObject(forKey: key)
    }
}
