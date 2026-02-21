import SwiftUI

struct FriendsView: View {
    @ObservedObject private var gameCenterManager = GameCenterManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if gameCenterManager.isAuthenticated {
                    Text("Connected to Game Center")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.green)

                    Button("View Leaderboard") {
                        // Game Center leaderboard would open here
                    }
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Text("Ghost runs and friend\nleaderboards available!")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Game Center requires an Apple ID")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Text("Make sure you're signed in with your Apple ID on your iPhone (Settings → Game Center)")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Try Again") {
                        gameCenterManager.authenticate()
                    }
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal, 8)
        }
        .navigationTitle("Friends")
        .onAppear {
            gameCenterManager.authenticate()
        }
    }
}
