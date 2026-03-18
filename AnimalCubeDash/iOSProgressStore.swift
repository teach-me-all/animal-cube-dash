import Foundation
import Combine

/// Stores game progress received from the Watch via WatchConnectivity.
final class iOSProgressStore: ObservableObject {
    static let shared = iOSProgressStore()

    @Published var currentLevel: Int = 1
    @Published var highestLevel: Int = 1
    @Published var totalLevelsCompleted: Int = 0
    @Published var unlockedSkins: [AnimalSkin] = [.cat]
    @Published var selectedSkin: AnimalSkin = .cat
    @Published var consecutivePerfectLevels: Int = 0
    @Published var lastSyncDate: Date?

    private let defaults = UserDefaults.standard

    private init() { load() }

    @discardableResult
    func completeLevel(_ level: Int, time: TimeInterval, deaths: Int) -> AnimalSkin? {
        totalLevelsCompleted += 1
        if deaths == 0 {
            consecutivePerfectLevels += 1
        } else {
            consecutivePerfectLevels = 0
        }
        if level >= highestLevel {
            highestLevel = level + 1
        }
        currentLevel = highestLevel  // always resume at the frontier
        let livesRemaining = Constants.maxLives - deaths
        let unlocked = checkSkinUnlocks(livesRemaining: livesRemaining)
        save()
        return unlocked
    }

    @discardableResult
    func checkSkinUnlocks(livesRemaining: Int = 0) -> AnimalSkin? {
        for skin in AnimalSkin.allCases {
            if !unlockedSkins.contains(skin) && highestLevel > skin.unlockLevel {
                switch skin.rarity {
                case .common, .rare, .ultraRare:
                    if totalLevelsCompleted >= 10 {
                        unlockedSkins.append(skin)
                        return skin
                    }
                case .epic:
                    if livesRemaining >= 2 {
                        unlockedSkins.append(skin)
                        return skin
                    }
                case .legendary:
                    if consecutivePerfectLevels >= 5 {
                        unlockedSkins.append(skin)
                        return skin
                    }
                }
            }
        }
        return nil
    }

    func update(from dict: [String: Any]) {
        DispatchQueue.main.async {
            if let v = dict["highestLevel"] as? Int { self.highestLevel = v }
            if let v = dict["currentLevel"] as? Int { self.currentLevel = v }
            if let v = dict["totalLevelsCompleted"] as? Int { self.totalLevelsCompleted = v }
            if let raws = dict["unlockedSkins"] as? [String] {
                self.unlockedSkins = raws.compactMap { AnimalSkin(rawValue: $0) }
                if self.unlockedSkins.isEmpty { self.unlockedSkins = [.cat] }
            }
            if let raw = dict["selectedSkin"] as? String {
                self.selectedSkin = AnimalSkin(rawValue: raw) ?? .cat
            }
            if let v = dict["consecutivePerfectLevels"] as? Int {
                self.consecutivePerfectLevels = v
            }
            self.lastSyncDate = Date()
            self.save()
        }
    }

    private func save() {
        defaults.set(currentLevel, forKey: "ios_currentLevel")
        defaults.set(highestLevel, forKey: "ios_highestLevel")
        defaults.set(totalLevelsCompleted, forKey: "ios_totalLevelsCompleted")
        defaults.set(unlockedSkins.map { $0.rawValue }, forKey: "ios_unlockedSkins")
        defaults.set(selectedSkin.rawValue, forKey: "ios_selectedSkin")
        defaults.set(consecutivePerfectLevels, forKey: "ios_consecutivePerfectLevels")
    }

    private func load() {
        let d = defaults
        let lvl = d.integer(forKey: "ios_highestLevel")
        highestLevel = lvl == 0 ? 1 : lvl
        let cur = d.integer(forKey: "ios_currentLevel")
        currentLevel = cur == 0 ? highestLevel : cur
        totalLevelsCompleted = d.integer(forKey: "ios_totalLevelsCompleted")
        if let raws = d.stringArray(forKey: "ios_unlockedSkins") {
            unlockedSkins = raws.compactMap { AnimalSkin(rawValue: $0) }
            if unlockedSkins.isEmpty { unlockedSkins = [.cat] }
        }
        selectedSkin = AnimalSkin(rawValue: d.string(forKey: "ios_selectedSkin") ?? "") ?? .cat
        consecutivePerfectLevels = d.integer(forKey: "ios_consecutivePerfectLevels")

        // Retroactively unlock any skins earned before the unlock system was in place
        checkSkinUnlocks()
    }
}
