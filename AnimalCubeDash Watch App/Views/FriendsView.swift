import SwiftUI

struct FriendsView: View {
    @ObservedObject private var gameCenterManager = GameCenterManager.shared
    @AppStorage("playerName") private var playerName = ""
    @State private var showNameEditor = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Profile / name section
                VStack(spacing: 6) {
                    Text(playerName.isEmpty ? "No name set" : playerName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(playerName.isEmpty ? .secondary : .primary)
                        .multilineTextAlignment(.center)

                    Button("Change Your Name") {
                        showNameEditor = true
                    }
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
                .padding(.vertical, 4)

                Divider()

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

                    Text("Sign in with Apple ID on your iPhone (Settings → Game Center)")
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
        .sheet(isPresented: $showNameEditor) {
            WatchNameEditorView(playerName: $playerName)
        }
    }
}

private struct WatchNameEditorView: View {
    @Binding var playerName: String
    @Environment(\.dismiss) private var dismiss
    @State private var draft = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Your Name")
                    .font(.system(size: 14, weight: .bold, design: .rounded))

                TextField("Enter name", text: $draft)
                    .font(.system(size: 13, design: .rounded))
                    .autocorrectionDisabled()

                Button("Save") {
                    let trimmed = draft.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        playerName = trimmed
                        dismiss()
                    }
                }
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)

                Button("Cancel") { dismiss() }
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .onAppear { draft = playerName }
    }
}
