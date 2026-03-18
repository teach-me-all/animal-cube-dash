import SwiftUI

// Matches the watch app's dark gaming theme

private let darkBg = Color(red: 0.08, green: 0.10, blue: 0.14)
private let cardBg = Color(red: 0.13, green: 0.16, blue: 0.22)

struct iOSHomeView: View {
    @EnvironmentObject var store: iOSProgressStore
    @EnvironmentObject var connectivity: PhoneConnectivityManager

    @StateObject private var updateChecker = AppUpdateChecker.shared
    @State private var isPlayActive = false
    @State private var pendingLevel = 0

    var body: some View {
        TabView {
            homeTab
                .tabItem { Label("Home", systemImage: "house.fill") }
            iOSSkinsView()
                .tabItem { Label("Skins", systemImage: "paintpalette.fill") }
            iOSLeaderboardView()
                .tabItem { Label("Leaderboard", systemImage: "trophy.fill") }
            iOSFriendsView()
                .tabItem { Label("Friends", systemImage: "person.2.fill") }
        }
        .tint(.green)
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BannerAdContainer()
        }
    }

    private var homeTab: some View {
        NavigationStack {
            ZStack {
                darkBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        if updateChecker.updateAvailable {
                            updateBanner
                        }
                        playCard
                        statsGrid
                        currentSkinCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                .onAppear { updateChecker.checkForUpdate() }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $isPlayActive) {
                iOSGameContainerView(level: pendingLevel, skin: store.selectedSkin)
                    .environmentObject(store)
            }
        }
    }

    // MARK: - Update Banner

    private var updateBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text("Update Available!")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                if let v = updateChecker.latestVersion {
                    Text("Version \(v) is on the App Store")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
            }
            Spacer()
            if let url = URL(string: "https://apps.apple.com/us/app/animal-cube-dash/id6759482553") {
                Link("Update", destination: url)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.white))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.orange)
                .shadow(color: .orange.opacity(0.4), radius: 6)
        )
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("🐾")
                .font(.system(size: 52))
                .padding(.top, 20)
            Text("Animal Cube Dash")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing)
                )
            Text("by Ahaana Sistla")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
        }
    }

    // MARK: - Play Card

    private var playCard: some View {
        Button {
            pendingLevel = store.currentLevel
            if AdManager.shared.shouldShowPrePlayAd(level: pendingLevel) {
                AdManager.shared.showPrePlayAd(level: pendingLevel) {
                    isPlayActive = true
                }
            } else {
                isPlayActive = true
            }
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: "play.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("PLAY")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    Text("Level \(store.currentLevel) · \(store.selectedSkin.emoji) \(store.selectedSkin.displayName)")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.white.opacity(0.65))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.green.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.green.opacity(0.35), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Stats Grid

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            DarkStatCard(title: "Highest Level", value: "\(store.highestLevel)",
                         icon: "flag.checkered", color: .green)
            DarkStatCard(title: "Levels Done", value: "\(store.totalLevelsCompleted)",
                         icon: "checkmark.circle.fill", color: .cyan)
            DarkStatCard(title: "Skins Unlocked",
                         value: "\(store.unlockedSkins.count)/\(AnimalSkin.allCases.count)",
                         icon: "paintpalette.fill", color: .purple)
            DarkStatCard(title: "Perfect Streak", value: "\(store.consecutivePerfectLevels)",
                         icon: "flame.fill", color: .orange)
        }
    }

    // MARK: - Current Skin Card

    private var currentSkinCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CURRENT SKIN")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
                .tracking(1.5)

            HStack(spacing: 14) {
                Text(store.selectedSkin.emoji)
                    .font(.system(size: 44))
                    .frame(width: 64, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(store.selectedSkin.rarity.color.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(store.selectedSkin.rarity.color.opacity(0.4), lineWidth: 1)
                            )
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(store.selectedSkin.displayName)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(store.selectedSkin.rarity.displayName.uppercased())
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .foregroundColor(store.selectedSkin.rarity.color)
                        .tracking(1)
                }
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(cardBg)
            )
        }
    }
}

// MARK: - Dark Stat Card

struct DarkStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(cardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// Keep old StatCard as alias for any other uses
typealias StatCard = DarkStatCard
