import SwiftUI
import GameKit

struct iOSLeaderboardView: View {
    @State private var isAuthenticated = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.14).ignoresSafeArea()
                VStack(spacing: 0) {
                    if isAuthenticated {
                        leaderboardList
                    } else {
                        signInPrompt
                    }
                }
            }
            .navigationTitle("Leaderboard")
            .onAppear { authenticateGameCenter() }
        }
    }

    private var leaderboardList: some View {
        List {
            Section {
                LeaderboardRow(
                    title: "Highest Level",
                    subtitle: "Who reached the furthest?",
                    icon: "flag.checkered",
                    color: .orange
                ) { presentLeaderboard("com.animalcubedash.highestlevel") }

                LeaderboardRow(
                    title: "Best Time",
                    subtitle: "Fastest level completion",
                    icon: "stopwatch.fill",
                    color: .blue
                ) { presentLeaderboard("com.animalcubedash.besttime") }
            } header: {
                Text("Global Rankings")
            }
        }
        .listStyle(.insetGrouped)
    }

    private var signInPrompt: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "gamecontroller.fill")
                .font(.system(size: 52))
                .foregroundColor(.secondary)
            VStack(spacing: 8) {
                Text("Game Center Required")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text("Sign in to Game Center in Settings to view leaderboards and compete with friends.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            Spacer()
        }
    }

    private func authenticateGameCenter() {
        GKLocalPlayer.local.authenticateHandler = { _, _ in
            DispatchQueue.main.async {
                isAuthenticated = GKLocalPlayer.local.isAuthenticated
            }
        }
    }

    private func presentLeaderboard(_ id: String) {
        let vc = GKGameCenterViewController(leaderboardID: id,
                                            playerScope: .global,
                                            timeScope: .allTime)
        vc.gameCenterDelegate = GameCenterPresentationDelegate.shared
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else { return }
        root.present(vc, animated: true)
    }
}

struct LeaderboardRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

final class GameCenterPresentationDelegate: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterPresentationDelegate()
    func gameCenterViewControllerDidFinish(_ gc: GKGameCenterViewController) {
        gc.dismiss(animated: true)
    }
}
