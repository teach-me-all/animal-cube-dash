import SwiftUI

struct ShareBragView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    let message: String
    @State private var sentToFriends = false
    @State private var openedMessages = false
    @State private var showNoFriends = false
    @State private var showDictatePrompt = false

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                if showDictatePrompt {
                    dictatePromptSection
                } else {
                    mainSection
                }
            }
            .padding(.horizontal, 8)
        }
    }

    // MARK: - Main section

    private var mainSection: some View {
        VStack(spacing: 6) {
            Image(systemName: "megaphone.fill")
                .font(.system(size: 20))
                .foregroundColor(.orange)

            // Brag message box
            VStack(spacing: 3) {
                Text("YOUR BRAG")
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .foregroundColor(.orange.opacity(0.9))
                    .tracking(1)

                Text(message)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange.opacity(0.4), lineWidth: 1)
                    )
            )

            if showNoFriends {
                noFriendsSection
            } else if sentToFriends {
                Text("Sent!")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                    .transition(.scale)
            } else {
                Button {
                    sendToFriends()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 9))
                        Text("Send to Friends")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                    )
                }
                .buttonStyle(.plain)
            }

            Button {
                sendViaMessages()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 9))
                    Text("Send via Messages")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green)
                )
            }
            .buttonStyle(.plain)

            Button {
                dismiss()
            } label: {
                Text("Close")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Dictate prompt (shown after Messages opens)

    private var dictatePromptSection: some View {
        VStack(spacing: 8) {
            VStack(spacing: 2) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.green)
                Text("DICTATE THIS:")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(.green)
                    .tracking(1)
            }

            Text(message)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.green.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.6), lineWidth: 1)
                        )
                )

            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.12))
                    )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - No friends section

    private var noFriendsSection: some View {
        VStack(spacing: 4) {
            Text("No Game Center friends yet!")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.yellow)
                .multilineTextAlignment(.center)

            Button {
                inviteFriends()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 9))
                    Text("Invite Friends")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple)
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Actions

    private func sendToFriends() {
        let gc = GameCenterManager.shared
        if !gc.hasFriends {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                showNoFriends = true
            }
            return
        }
        gc.sendBragMessage(message)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            sentToFriends = true
        }
    }

    private func sendViaMessages() {
        // Try to pre-fill body via sms: URL scheme (works on some watchOS versions)
        let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "sms:?body=\(encoded)") ?? URL(string: "sms:")!
        openURL(url)

        // Show the dictate prompt so user sees the message to send
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showDictatePrompt = true
        }
    }

    private func inviteFriends() {
        if let url = URL(string: "sms:") {
            openURL(url)
        }
    }
}
