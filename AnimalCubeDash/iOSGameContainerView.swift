import SwiftUI
import SpriteKit
import UIKit

struct BragItem: Identifiable {
    let id = UUID()
    let message: String
}

class GameSceneHolder: ObservableObject {
    let scene: GameScene

    init(level: Int, skin: AnimalSkin) {
        scene = GameScene(size: Constants.sceneSize)
        scene.scaleMode = .aspectFill
        scene.configure(level: level, skin: skin)
    }
}

struct iOSGameContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: iOSProgressStore
    @State private var livesRemaining: Int = Constants.maxLives
    @State private var showLevelComplete = false
    @State private var showGameOver = false
    @State private var showPauseOverlay = false
    @State private var bragItem: BragItem? = nil
    @State private var completedLevel: Int = 0
    @State private var currentDisplayLevel: Int = 1
    /// false = waiting for user tap (either fresh start or after pause)
    @State private var gameStarted = false
    /// true = user paused and tapped "Resume" — next tap should resume (not restart)
    @State private var pendingResume = false
    /// true = next tap should advance to next level
    @State private var pendingNextLevel = false
    /// true = next tap should restart the current level
    @State private var pendingRestart = false
    @State private var gameOverProgress: Float = 0
    @State private var unlockedSkin: AnimalSkin? = nil
    @State private var showSkinUnlock = false
    @State private var showGiftBoxUnlock = false
    @State private var pendingUnlockAction: (() -> Void)? = nil

    @StateObject private var holder: GameSceneHolder

    let level: Int
    let skin: AnimalSkin

    init(level: Int, skin: AnimalSkin) {
        self.level = level
        self.skin = skin
        _currentDisplayLevel = State(initialValue: level)
        _holder = StateObject(wrappedValue: GameSceneHolder(level: level, skin: skin))
    }

    private var scene: GameScene { holder.scene }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            SpriteView(scene: scene, preferredFramesPerSecond: 60)
                .ignoresSafeArea()

            // Tap to Start / Tap to Continue overlay
            if !gameStarted && !showPauseOverlay && !showLevelComplete && !showGameOver {
                tapPromptOverlay
            }

            // Pause overlay
            if showPauseOverlay {
                iOSPauseOverlay(
                    onResume: {
                        // Don't resume immediately — show "Tap to Continue"
                        showPauseOverlay = false
                        gameStarted = false
                        pendingResume = true
                    },
                    onRestart: {
                        showPauseOverlay = false
                        gameStarted = false
                        pendingResume = false
                        pendingRestart = true
                    },
                    onHome: { dismiss() }
                )
            }

            // Banner ad pinned to top of screen during pause
            if showPauseOverlay {
                BannerAdContainer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }

            // Level Complete
            if showLevelComplete {
                iOSLevelCompleteOverlay(
                    level: completedLevel,
                    livesRemaining: livesRemaining,
                    onNextLevel: {
                        showLevelComplete = false
                        gameStarted = false
                        pendingResume = false
                        pendingNextLevel = true
                        currentDisplayLevel = completedLevel + 1
                        let skin = store.completeLevel(completedLevel,
                                                       time: 60,
                                                       deaths: Constants.maxLives - livesRemaining)
                        if let skin {
                            unlockedSkin = skin
                            pendingUnlockAction = nil  // next-level tap handled separately
                            if skin.rarity == .common || skin.rarity == .rare || skin.rarity == .ultraRare {
                                showSkinUnlock = true
                            } else {
                                showGiftBoxUnlock = true
                            }
                        }
                    },
                    onBrag: {
                        let deaths = Constants.maxLives - livesRemaining
                        let msg = BragMessageGenerator.shareMessage(
                            level: completedLevel,
                            livesRemaining: livesRemaining,
                            deaths: deaths)
                        bragItem = BragItem(message: msg)
                    },
                    onHome: {
                        showLevelComplete = false
                        let skin = store.completeLevel(completedLevel,
                                                       time: 60,
                                                       deaths: Constants.maxLives - livesRemaining)
                        if let skin {
                            unlockedSkin = skin
                            pendingUnlockAction = { dismiss() }
                            if skin.rarity == .common || skin.rarity == .rare || skin.rarity == .ultraRare {
                                showSkinUnlock = true
                            } else {
                                showGiftBoxUnlock = true
                            }
                        } else {
                            dismiss()
                        }
                    }
                )
            }

            // Game Over
            if showGameOver {
                iOSGameOverOverlay(
                    level: currentDisplayLevel,
                    progress: gameOverProgress,
                    onRetry: {
                        showGameOver = false
                        gameStarted = false
                        pendingResume = false
                        pendingRestart = true
                    },
                    onContinueWithAd: {
                        showGameOver = false
                        AdManager.shared.showRewardedAd {
                            // onReward — grant extra life and resume
                            scene.continueWithExtraLife()
                            gameStarted = true
                        } onDismiss: {
                            // user skipped — stay on game over (show it again)
                            showGameOver = true
                            gameStarted = false
                        }
                    },
                    onHome: {
                        showGameOver = false
                        dismiss()
                    }
                )
            }

            // Skin unlock — spin animation (Common/Rare/Ultra Rare)
            if showSkinUnlock, let skin = unlockedSkin {
                iOSSkinUnlockView(skin: skin) {
                    showSkinUnlock = false
                    unlockedSkin = nil
                    pendingUnlockAction?()
                    pendingUnlockAction = nil
                }
                .transition(.opacity)
                .zIndex(100)
            }

            // Gift box unlock (Epic/Legendary)
            if showGiftBoxUnlock, let skin = unlockedSkin {
                iOSGiftBoxUnlockView(skin: skin) {
                    showGiftBoxUnlock = false
                    unlockedSkin = nil
                    pendingUnlockAction?()
                    pendingUnlockAction = nil
                }
                .transition(.opacity)
                .zIndex(100)
            }

            // Hearts — top left during active play
            if gameStarted && !showPauseOverlay && !showLevelComplete && !showGameOver {
                VStack {
                    HStack(spacing: 5) {
                        ForEach(0..<Constants.maxLives, id: \.self) { i in
                            Image(systemName: i < livesRemaining ? "heart.fill" : "heart")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(i < livesRemaining ? .red : .white.opacity(0.35))
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    Spacer()
                }
            }

            // Level indicator — top center during active play
            if gameStarted && !showPauseOverlay && !showLevelComplete && !showGameOver {
                VStack {
                    Text("LEVEL \(currentDisplayLevel)")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .tracking(1.5)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.45))
                        )
                        .padding(.top, 10)
                    Spacer()
                }
            }

            // Pause button — visible during active play, hidden when pause overlay is showing
            if gameStarted && !showPauseOverlay {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            scene.togglePause()
                            showPauseOverlay = true
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.45))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                        }
                        .padding(.trailing, 14)
                        .padding(.top, 14)
                    }
                    Spacer()
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    guard gameStarted, !showPauseOverlay, !showLevelComplete, !showGameOver else { return }
                    let vertical = value.translation.height
                    let horizontal = value.translation.width
                    if vertical > 20 && abs(vertical) > abs(horizontal) {
                        scene.handleSwipeDown()
                    }
                }
        )
        .onTapGesture {
            guard !showPauseOverlay, !showLevelComplete, !showGameOver else { return }
            if !gameStarted {
                gameStarted = true
                if pendingResume {
                    pendingResume = false
                    scene.resumeGame()
                } else if pendingNextLevel {
                    pendingNextLevel = false
                    AdManager.shared.onLevelStarted(level: currentDisplayLevel)
                    scene.nextLevel()
                } else if pendingRestart {
                    pendingRestart = false
                    AdManager.shared.onLevelStarted(level: currentDisplayLevel)
                    scene.restartLevel()
                } else {
                    AdManager.shared.onLevelStarted(level: currentDisplayLevel)
                    scene.startGame()
                }
            } else {
                scene.handleTap()
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden(true)
        .toolbar(showPauseOverlay ? .visible : .hidden, for: .tabBar)
        .sheet(item: $bragItem) { item in
            iOSBragSheet(message: item.message)
        }
        .onAppear {
            scene.onStateChange = { _ in }
            scene.onLivesChange = { lives in
                DispatchQueue.main.async { livesRemaining = lives }
            }
            scene.onLevelComplete = { lvl in
                DispatchQueue.main.async {
                    completedLevel = lvl
                    gameStarted = false
                    AdManager.shared.onLevelCompleted(level: lvl)
                    if AdManager.shared.shouldShowPostLevelAd(level: lvl) {
                        AdManager.shared.showPostLevelAd(level: lvl) {
                            showLevelComplete = true
                        }
                    } else {
                        showLevelComplete = true
                    }
                }
            }
            scene.onGameOver = {
                DispatchQueue.main.async {
                    gameOverProgress = scene.playerProgress
                    showGameOver = true
                    gameStarted = false
                }
            }
            // Do NOT call startGame() — wait for tap
        }
        .onDisappear { }
    }

    // MARK: - Tap Prompt Overlay

    private var tapPromptOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack(spacing: 14) {
                Text(skin.emoji)
                    .font(.system(size: 56))

                Text("Level \(currentDisplayLevel)")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.65))

                Text(pendingResume ? "TAP TO CONTINUE" : "TAP TO START")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .green.opacity(0.9), radius: 10)
                    .modifier(PulseModifier())
            }
        }
    }

}

// MARK: - Pulse Animation Modifier

private struct PulseModifier: ViewModifier {
    @State private var scale: CGFloat = 1.0

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    scale = 1.08
                }
            }
    }
}

// MARK: - Pause Overlay

private struct iOSPauseOverlay: View {
    let onResume: () -> Void
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.65).ignoresSafeArea()
            HStack(spacing: 24) {
                VStack(spacing: 6) {
                    Text("⏸")
                        .font(.system(size: 36))
                    Text("PAUSED")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                }
                VStack(spacing: 14) {
                    Button("Resume") { onResume() }
                        .buttonStyle(GameButtonStyle(color: .green))
                    Button("Restart") { onRestart() }
                        .buttonStyle(GameButtonStyle(color: .orange))
                    Button("Home") { onHome() }
                        .buttonStyle(GameButtonStyle(color: Color(red: 0.3, green: 0.3, blue: 0.35)))
                }
            }
        }
    }
}

// MARK: - Level Complete Overlay

private struct iOSLevelCompleteOverlay: View {
    let level: Int
    let livesRemaining: Int
    let onNextLevel: () -> Void
    let onBrag: () -> Void
    let onHome: () -> Void

    @State private var confettiPieces: [iOSConfettiPiece] = []
    @State private var confettiFalling = false
    @State private var showBanner = false
    @State private var titleScale: CGFloat = 0.3
    @State private var titleGlow = false
    @State private var starBounce = false

    var body: some View {
        ZStack {
            // Confetti
            ForEach(confettiPieces) { piece in
                RoundedRectangle(cornerRadius: 2)
                    .fill(piece.color)
                    .frame(width: piece.size * 0.4, height: piece.size)
                    .rotationEffect(.degrees(confettiFalling ? piece.rotation : 0))
                    .position(
                        x: confettiFalling ? piece.endX : UIScreen.main.bounds.width / 2,
                        y: confettiFalling ? piece.endY : UIScreen.main.bounds.height
                    )
                    .opacity(confettiFalling ? 0 : 1)
                    .animation(
                        .easeOut(duration: piece.duration).delay(piece.delay),
                        value: confettiFalling
                    )
            }

            if showBanner {
                VStack(spacing: 0) {
                    // Stars + title
                    VStack(spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.yellow)
                                .scaleEffect(starBounce ? 1.2 : 0.8)
                                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: starBounce)
                            Image(systemName: "star.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.orange)
                                .scaleEffect(starBounce ? 1.3 : 0.9)
                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: starBounce)
                            Image(systemName: "star.fill")
                                .font(.system(size: 18))
                                .foregroundColor(.yellow)
                                .scaleEffect(starBounce ? 1.2 : 0.8)
                                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.2), value: starBounce)
                        }

                        Text("YOU DID IT!")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange, .pink, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .orange.opacity(0.8), radius: titleGlow ? 12 : 4)
                            .scaleEffect(titleScale)
                            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: titleScale)

                        Text("Level \(level)")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)

                    // Buttons
                    HStack(spacing: 14) {
                        Button(action: onNextLevel) {
                            Text("Next Level")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 130)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
                                        .shadow(color: .green.opacity(0.5), radius: 6)
                                )
                        }
                        .buttonStyle(.plain)

                        Button(action: onBrag) {
                            HStack(spacing: 6) {
                                Image(systemName: "megaphone.fill")
                                    .font(.system(size: 13))
                                Text("Brag")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(width: 130)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: .orange.opacity(0.4), radius: 6)
                            )
                        }
                        .buttonStyle(.plain)

                        Button(action: onHome) {
                            Text("Home")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.75))
                                .frame(width: 100)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.12))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .transition(.scale(scale: 0.5).combined(with: .opacity))
                .onAppear {
                    titleScale = 1.0
                    titleGlow = true
                    starBounce = true
                }
            }
        }
        .onAppear {
            generateConfetti()
            withAnimation { confettiFalling = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showBanner = true
                }
            }
        }
    }

    private func generateConfetti() {
        let colors: [Color] = [.red, .yellow, .blue, .green, .pink, .orange, .purple, .mint, .cyan, .indigo]
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        confettiPieces = (0..<45).map { i in
            let angle = Double.random(in: 0.3...2.9)
            let distance = CGFloat.random(in: 150...500)
            return iOSConfettiPiece(
                id: i,
                color: colors[i % colors.count],
                size: CGFloat.random(in: 16...32),
                endX: w / 2 - cos(angle) * distance,
                endY: h - sin(angle) * distance,
                rotation: Double.random(in: -540...540),
                duration: Double.random(in: 3.0...4.0),
                delay: Double.random(in: 0...0.8)
            )
        }
    }
}

private struct iOSConfettiPiece: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let rotation: Double
    let duration: Double
    let delay: Double
}

// MARK: - Game Over Overlay

private struct iOSGameOverOverlay: View {
    let level: Int
    let progress: Float
    let onRetry: () -> Void
    let onContinueWithAd: () -> Void
    let onHome: () -> Void

    @ObservedObject private var adManager = AdManager.shared

    var body: some View {
        ZStack {
            Color.black.opacity(0.75).ignoresSafeArea()
            VStack(spacing: 14) {
                Text("💀")
                    .font(.system(size: 44))
                Text("Game Over")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                Text("Level \(level)")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))

                if adManager.canShowRewardedAd(progress: progress) {
                    Button {
                        onContinueWithAd()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "play.rectangle.fill")
                            Text("Watch ad for +1 life")
                        }
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 240)
                        .padding(.vertical, 12)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.yellow))
                    }
                    .buttonStyle(.plain)
                }

                HStack(spacing: 14) {
                    Button("Try Again") { onRetry() }
                        .buttonStyle(GameButtonStyle(color: .orange))
                    Button("Home") { onHome() }
                        .buttonStyle(GameButtonStyle(color: Color(red: 0.3, green: 0.3, blue: 0.35)))
                }
            }
        }
    }
}

// MARK: - Brag Sheet

private struct iOSBragSheet: View {
    let message: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.14).ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("Your Brag")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)

                    Text(message)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.15))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.4), lineWidth: 1))
                        )
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        // Send to Friends via system share sheet
                        ShareLink(item: message) {
                            Label("Send to Friends", systemImage: "person.2.fill")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)

                        // Send via WhatsApp
                        Button {
                            sendViaWhatsApp()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "message.fill")
                                    .font(.system(size: 16, weight: .bold))
                                Text("via WhatsApp")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.07, green: 0.57, blue: 0.27)))
                            .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)

                        // Send via Messages
                        Button {
                            sendViaMessages()
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "message.fill")
                                    .font(.system(size: 16, weight: .bold))
                                Text("via Messages")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.20, green: 0.60, blue: 1.0)))
                            .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top, 24)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(.green)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func sendViaMessages() {
        guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "sms:&body=\(encoded)") else { return }
        UIApplication.shared.open(url)
    }

    private func sendViaWhatsApp() {
        guard let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "whatsapp://send?text=\(encoded)") else { return }
        UIApplication.shared.open(url) { success in
            if !success {
                // WhatsApp not installed — open App Store
                if let appStoreURL = URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997") {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        }
    }
}

// MARK: - Button Style

struct GameButtonStyle: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: 130)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 12).fill(color.opacity(configuration.isPressed ? 0.65 : 1.0)))
    }
}
