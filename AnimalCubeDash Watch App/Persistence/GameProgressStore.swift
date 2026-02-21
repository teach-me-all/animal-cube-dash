import Foundation

final class GameProgressStore: ObservableObject {
    static let shared = GameProgressStore()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let currentLevel = "currentLevel"
        static let highestLevel = "highestLevel"
        static let selectedSkin = "selectedSkin"
        static let unlockedSkins = "unlockedSkins"
        static let totalDeaths = "totalDeaths"
        static let totalLevelsCompleted = "totalLevelsCompleted"
        static let bestTimes = "bestTimes" // [Int: TimeInterval] as dict
        static let lastPlayedDate = "lastPlayedDate"
        static let consecutivePerfectLevels = "consecutivePerfectLevels"
    }

    @Published var currentLevel: Int {
        didSet { defaults.set(currentLevel, forKey: Keys.currentLevel) }
    }

    @Published var highestLevel: Int {
        didSet { defaults.set(highestLevel, forKey: Keys.highestLevel) }
    }

    @Published var selectedSkin: AnimalSkin {
        didSet { defaults.set(selectedSkin.rawValue, forKey: Keys.selectedSkin) }
    }

    @Published var unlockedSkins: [AnimalSkin] {
        didSet {
            let raw = unlockedSkins.map { $0.rawValue }
            defaults.set(raw, forKey: Keys.unlockedSkins)
        }
    }

    @Published var totalDeaths: Int {
        didSet { defaults.set(totalDeaths, forKey: Keys.totalDeaths) }
    }

    @Published var totalLevelsCompleted: Int {
        didSet { defaults.set(totalLevelsCompleted, forKey: Keys.totalLevelsCompleted) }
    }

    @Published var consecutivePerfectLevels: Int {
        didSet { defaults.set(consecutivePerfectLevels, forKey: Keys.consecutivePerfectLevels) }
    }

    private(set) var bestTimes: [Int: TimeInterval] = [:]

    private init() {
        let d = UserDefaults.standard
        let savedLevel = d.integer(forKey: Keys.currentLevel)
        _currentLevel = Published(initialValue: savedLevel == 0 ? 1 : savedLevel)

        let savedHighest = d.integer(forKey: Keys.highestLevel)
        _highestLevel = Published(initialValue: savedHighest == 0 ? 1 : savedHighest)

        if let skinRaw = d.string(forKey: Keys.selectedSkin),
           let skin = AnimalSkin(rawValue: skinRaw) {
            _selectedSkin = Published(initialValue: skin)
        } else {
            _selectedSkin = Published(initialValue: .cat)
        }

        if let rawSkins = d.stringArray(forKey: Keys.unlockedSkins) {
            _unlockedSkins = Published(initialValue: rawSkins.compactMap { AnimalSkin(rawValue: $0) })
        } else {
            _unlockedSkins = Published(initialValue: [.cat])
        }

        _totalDeaths = Published(initialValue: d.integer(forKey: Keys.totalDeaths))
        _totalLevelsCompleted = Published(initialValue: d.integer(forKey: Keys.totalLevelsCompleted))
        _consecutivePerfectLevels = Published(initialValue: d.integer(forKey: Keys.consecutivePerfectLevels))

        if let timesData = d.dictionary(forKey: Keys.bestTimes) as? [String: TimeInterval] {
            bestTimes = Dictionary(uniqueKeysWithValues: timesData.compactMap {
                guard let key = Int($0.key) else { return nil }
                return (key, $0.value)
            })
        }
    }

    @discardableResult
    func completeLevel(_ level: Int, time: TimeInterval, deaths: Int) -> AnimalSkin? {
        totalLevelsCompleted += 1
        totalDeaths += deaths

        // Track consecutive perfect (no death) levels for Legendary unlocks
        if deaths == 0 {
            consecutivePerfectLevels += 1
        } else {
            consecutivePerfectLevels = 0
        }

        if level >= highestLevel {
            highestLevel = level + 1
            currentLevel = level + 1
        }

        // Best time
        if bestTimes[level] == nil || time < bestTimes[level]! {
            bestTimes[level] = time
            saveBestTimes()
        }

        // Check skin unlocks
        let livesRemaining = Constants.maxLives - deaths
        return checkSkinUnlocks(livesRemaining: livesRemaining)
    }

    @discardableResult
    func checkSkinUnlocks(livesRemaining: Int = 0) -> AnimalSkin? {
        for skin in AnimalSkin.allCases {
            if !unlockedSkins.contains(skin) && highestLevel > skin.unlockLevel {
                // Common skins require completing 10 levels (cat is free)
                // Rare, Ultra Rare, and Epic require finishing with 2+ lives
                // Legendary requires 5 consecutive levels with no lives lost
                if skin.rarity == .common && totalLevelsCompleted >= 10 {
                    unlockedSkins.append(skin)
                    return skin
                } else if skin.rarity == .legendary && consecutivePerfectLevels >= 5 {
                    unlockedSkins.append(skin)
                    return skin
                } else if skin.rarity != .common && skin.rarity != .legendary && livesRemaining >= 2 {
                    unlockedSkins.append(skin)
                    return skin
                }
            }
        }
        return nil
    }

    func bestTime(for level: Int) -> TimeInterval? {
        bestTimes[level]
    }

    private func saveBestTimes() {
        let stringKeyed = Dictionary(uniqueKeysWithValues: bestTimes.map { (String($0.key), $0.value) })
        defaults.set(stringKeyed, forKey: Keys.bestTimes)
    }

    func resetProgress() {
        currentLevel = 1
        highestLevel = 1
        selectedSkin = .cat
        unlockedSkins = [.cat]
        totalDeaths = 0
        totalLevelsCompleted = 0
        consecutivePerfectLevels = 0
        bestTimes = [:]
        saveBestTimes()
    }
}
