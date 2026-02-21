import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var store: GameProgressStore
    @State private var bragMessage = ""
    @State private var bragTimer: Timer?
    @State private var skinPulse = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Center group: title + character + play button + level
            VStack(spacing: 4) {
                Text("Cube Dash")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                Text("By Ahaana Sistla!")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundColor(.cyan)

                // Current skin character preview
                Text(store.selectedSkin.emoji)
                    .font(.system(size: 24))
                    .padding(.top, 2)

                // Play Button
                NavigationLink {
                    GameContainerView(level: store.currentLevel, skin: store.selectedSkin)
                        .environmentObject(store)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 14))
                        Text("PLAY")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green, Color.green.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .green.opacity(0.4), radius: 4, y: 2)
                    )
                }
                .buttonStyle(.plain)

                // Level indicator
                Text("Level \(store.currentLevel)")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.white.opacity(0.15)))
            }

            Spacer()

            // Brag Message Banner
            if !bragMessage.isEmpty {
                Text(bragMessage)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.yellow.opacity(0.1))
                    )
                    .transition(.opacity)
            }

            // Bottom row: Friends & Skins side by side
            HStack(spacing: 6) {
                NavigationLink {
                    FriendsView()
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 13))
                        Text("Friends")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.15))
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    SkinsGalleryView()
                        .environmentObject(store)
                } label: {
                    VStack(spacing: 2) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 13))
                        Text("Skins")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple.opacity(0.15))
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 4)
        }
        .padding(.horizontal, 8)
        .toolbar(.hidden)
        .onAppear {
            rotateBragMessage()
        }
        .onDisappear {
            bragTimer?.invalidate()
        }
    }

    private func rotateBragMessage() {
        updateBragMessage()
        bragTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                updateBragMessage()
            }
        }
    }

    private func updateBragMessage() {
        bragMessage = BragMessageGenerator.homeBannerMessage(store: store)
    }
}
