import SwiftUI

struct ShareBragView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    let message: String
    @State private var sentToFriends = false
    @State private var openedMessages = false
    @State private var showNoFriends = false

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Image(systemName: "megaphone.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)

                Text(message)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)

                if showNoFriends {
                    // No Game Center friends — offer invite
                    noFriendsSection
                } else if sentToFriends {
                    Text("Sent!")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                        .transition(.scale)
                } else {
                    // Send to Game Center friends
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

                // Send via Messages app
                if openedMessages {
                    Text("Messages opened!")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.green)
                        .transition(.scale)
                } else {
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
                }

                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)
        }
    }

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
        // Open Messages app via sms: URL scheme
        // watchOS doesn't support pre-filling body, user types the message
        if let url = URL(string: "sms:") {
            openURL(url)
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            openedMessages = true
        }
    }

    private func inviteFriends() {
        // Open Messages so the user can text friends to download the app
        if let url = URL(string: "sms:") {
            openURL(url)
        }
    }
}
