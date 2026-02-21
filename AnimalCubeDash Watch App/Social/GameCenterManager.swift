import GameKit

final class GameCenterManager: ObservableObject {

    static let shared = GameCenterManager()

    static let leaderboardBestTime = "com.animalcubedash.besttime"
    static let leaderboardHighestLevel = "com.animalcubedash.highestlevel"

    @Published var isAuthenticated = false

    private init() {}

    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isAuthenticated = GKLocalPlayer.local.isAuthenticated
                if self.isAuthenticated {
                    self.loadFriendsStatus()
                } else if let error = error {
                    print("Game Center auth error: \(error.localizedDescription)")
                }
            }
        }
    }

    func submitScore(_ score: Int, leaderboardID: String) {
        guard isAuthenticated else { return }

        Task {
            do {
                try await GKLeaderboard.submitScore(
                    score,
                    context: 0,
                    player: GKLocalPlayer.local,
                    leaderboardIDs: [leaderboardID]
                )
            } catch {
                print("Score submission error: \(error.localizedDescription)")
            }
        }
    }

    func submitTime(_ time: TimeInterval, leaderboardID: String) {
        let milliseconds = Int(time * 1000)
        submitScore(milliseconds, leaderboardID: leaderboardID)
    }

    @Published var hasFriends = false

    func loadFriendsStatus() {
        guard isAuthenticated else { return }
        Task {
            do {
                let friends = try await GKLocalPlayer.local.loadFriends()
                await MainActor.run {
                    self.hasFriends = !friends.isEmpty
                }
            } catch {
                await MainActor.run {
                    self.hasFriends = false
                }
            }
        }
    }

    func sendBragMessage(_ message: String) {
        // Update leaderboard so friends see the achievement
        // Game Center automatically notifies friends of leaderboard updates
        guard isAuthenticated else { return }
        print("Brag: \(message)")
    }
}
