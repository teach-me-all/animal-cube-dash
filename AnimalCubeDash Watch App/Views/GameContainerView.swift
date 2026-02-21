import SwiftUI
import SpriteKit

class GameSceneHolder: ObservableObject {
    let scene: GameScene

    init(level: Int, skin: AnimalSkin) {
        scene = GameScene(size: Constants.sceneSize)
        scene.scaleMode = .aspectFill
        scene.configure(level: level, skin: skin)
    }
}

struct GameContainerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: GameProgressStore
    @State private var gameState: GameStateType = .playing
    @State private var livesRemaining: Int = Constants.maxLives
    @State private var crownValue: Double = 0
    @State private var showLevelComplete = false
    @State private var showGameOver = false
    @State private var showBragSheet = false
    @State private var bragText = ""
    @State private var completedLevel: Int = 0
    @State private var showGiftBox = false
    @State private var showCommonUnlock = false
    @State private var unlockedSkin: AnimalSkin?
    @State private var pendingAction: (() -> Void)?
    @StateObject private var holder: GameSceneHolder

    let level: Int
    let skin: AnimalSkin

    init(level: Int, skin: AnimalSkin) {
        self.level = level
        self.skin = skin
        _holder = StateObject(wrappedValue: GameSceneHolder(level: level, skin: skin))
    }

    private var scene: GameScene { holder.scene }

    var body: some View {
        ZStack {
            SpriteView(scene: scene, preferredFramesPerSecond: 30)
                .ignoresSafeArea()

            // Pause overlay
            if gameState == .paused {
                PauseOverlayView(
                    onResume: { scene.resumeGame() },
                    onRestart: { scene.restartLevel() }
                )
            }

            // Level Complete
            if showLevelComplete {
                LevelCompleteView(
                    level: completedLevel,
                    onNextLevel: {
                        showLevelComplete = false
                        let skin = store.completeLevel(completedLevel, time: 60, deaths: Constants.maxLives - livesRemaining)
                        if let skin = skin {
                            unlockedSkin = skin
                            pendingAction = { scene.nextLevel() }
                            if skin.rarity == .common {
                                showCommonUnlock = true
                            } else {
                                showGiftBox = true
                            }
                        } else {
                            scene.nextLevel()
                        }
                    },
                    onBrag: {
                        let deaths = Constants.maxLives - livesRemaining
                        bragText = BragMessageGenerator.shareMessage(level: completedLevel, livesRemaining: livesRemaining, deaths: deaths)
                        showBragSheet = true
                    },
                    onHome: {
                        showLevelComplete = false
                        let skin = store.completeLevel(completedLevel, time: 60, deaths: Constants.maxLives - livesRemaining)
                        if let skin = skin {
                            unlockedSkin = skin
                            pendingAction = { dismiss() }
                            if skin.rarity == .common {
                                showCommonUnlock = true
                            } else {
                                showGiftBox = true
                            }
                        } else {
                            dismiss()
                        }
                    }
                )
            }

            // Gift box for rare+ skin unlocks
            if showGiftBox, let skin = unlockedSkin {
                GiftBoxView(skin: skin) {
                    showGiftBox = false
                    unlockedSkin = nil
                    pendingAction?()
                    pendingAction = nil
                }
            }

            // Common skin unlock
            if showCommonUnlock, let skin = unlockedSkin {
                CommonSkinUnlockView(skin: skin) {
                    showCommonUnlock = false
                    unlockedSkin = nil
                    pendingAction?()
                    pendingAction = nil
                }
            }

            // Game Over
            if showGameOver {
                GameOverView(
                    level: level,
                    onRetry: {
                        showGameOver = false
                        scene.restartLevel()
                    },
                    onHome: {
                        showGameOver = false
                        dismiss()
                    }
                )
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 10)
                .onEnded { value in
                    let vertical = value.translation.height
                    let horizontal = value.translation.width
                    // Swipe down: vertical > 0 and more vertical than horizontal
                    if vertical > 20 && abs(vertical) > abs(horizontal) {
                        scene.handleSwipeDown()
                    }
                }
        )
        .onTapGesture {
            scene.handleTap()
        }
        .focusable()
        .digitalCrownRotation(
            $crownValue,
            from: -0.1, through: 0.1,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: false
        )
        .onChange(of: crownValue) { _, newValue in
            scene.updateCrownValue(newValue)
        }
        .navigationBarBackButtonHidden(gameState == .playing)
        .sheet(isPresented: $showBragSheet) {
            ShareBragView(message: bragText)
        }
        .onAppear {
            scene.onStateChange = { state in
                DispatchQueue.main.async { gameState = state }
            }
            scene.onLivesChange = { lives in
                DispatchQueue.main.async { livesRemaining = lives }
            }
            scene.onLevelComplete = { lvl in
                DispatchQueue.main.async {
                    completedLevel = lvl
                    showLevelComplete = true
                }
            }
            scene.onGameOver = {
                DispatchQueue.main.async { showGameOver = true }
            }
            scene.startGame()
        }
    }
}
