import Foundation

final class DailyChallengeManager {

    static let shared = DailyChallengeManager()

    private let defaults = UserDefaults.standard
    private let calendar = Calendar.current

    private init() {}

    // MARK: - Seed

    var todaySeed: UInt64 {
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2026
        let month = components.month ?? 1
        let day = components.day ?? 1
        return UInt64(year * 10000 + month * 100 + day)
    }

    // MARK: - Date String

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    // MARK: - Play State

    var hasPlayedToday: Bool {
        let key = "dailyChallenge_\(dateString)"
        return defaults.bool(forKey: key)
    }

    func markPlayed(time: TimeInterval, deaths: Int) {
        let key = "dailyChallenge_\(dateString)"
        defaults.set(true, forKey: key)

        let timeKey = "dailyChallengeTime_\(dateString)"
        let deathsKey = "dailyChallengeDeaths_\(dateString)"
        defaults.set(time, forKey: timeKey)
        defaults.set(deaths, forKey: deathsKey)
    }

    func todayResult() -> (time: TimeInterval, deaths: Int)? {
        guard hasPlayedToday else { return nil }

        let timeKey = "dailyChallengeTime_\(dateString)"
        let deathsKey = "dailyChallengeDeaths_\(dateString)"

        let time = defaults.double(forKey: timeKey)
        let deaths = defaults.integer(forKey: deathsKey)

        return (time: time, deaths: deaths)
    }
}
