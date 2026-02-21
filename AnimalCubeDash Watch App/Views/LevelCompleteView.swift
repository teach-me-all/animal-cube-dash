import SwiftUI

struct LevelCompleteView: View {
    let level: Int
    let onNextLevel: () -> Void
    let onBrag: () -> Void
    let onHome: () -> Void

    @State private var confettiPieces: [ConfettiPiece] = []
    @State private var confettiFalling = false
    @State private var showBanner = false
    @State private var titleScale: CGFloat = 0.3
    @State private var titleGlow = false
    @State private var starBounce = false

    var body: some View {
        ZStack {
            // Full-screen confetti layer
            ForEach(confettiPieces) { piece in
                RoundedRectangle(cornerRadius: 2)
                    .fill(piece.color)
                    .frame(width: piece.size * 0.4, height: piece.size)
                    .rotationEffect(.degrees(confettiFalling ? piece.rotation : 0))
                    .position(
                        x: confettiFalling ? piece.endX : 175,
                        y: confettiFalling ? piece.endY : 230
                    )
                    .opacity(confettiFalling ? 0 : 1)
                    .animation(
                        .easeOut(duration: piece.duration)
                            .delay(piece.delay),
                        value: confettiFalling
                    )
            }

            // Banner (appears after confetti starts)
            if showBanner {
                // Title pinned to top
                VStack(spacing: 1) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                            .scaleEffect(starBounce ? 1.2 : 0.8)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: starBounce)
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                            .scaleEffect(starBounce ? 1.3 : 0.9)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: starBounce)
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                            .scaleEffect(starBounce ? 1.2 : 0.8)
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.2), value: starBounce)
                    }

                    Text("YOU DID IT!")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .pink, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .orange.opacity(0.8), radius: titleGlow ? 8 : 3)
                        .scaleEffect(titleScale)
                        .animation(.spring(response: 0.4, dampingFraction: 0.5), value: titleScale)

                    Text("Level \(level)")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 2)

                // Buttons pinned to bottom
                VStack(spacing: 2) {
                    Button(action: onNextLevel) {
                        Text("Next Level")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .mint],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: .green.opacity(0.5), radius: 3)
                            )
                    }
                    .buttonStyle(.plain)

                    Button(action: onBrag) {
                        HStack(spacing: 3) {
                            Image(systemName: "megaphone.fill")
                                .font(.system(size: 7))
                            Text("Brag")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 3)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: [.orange, .red],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .orange.opacity(0.4), radius: 3)
                        )
                    }
                    .buttonStyle(.plain)

                    Button(action: onHome) {
                        Text("Home")
                            .font(.system(size: 8, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 4)
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
            // Start confetti falling immediately
            withAnimation {
                confettiFalling = true
            }
            // Show the banner after 4 seconds (confetti finishes)
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showBanner = true
                }
            }
        }
    }

    private func generateConfetti() {
        let colors: [Color] = [.red, .yellow, .blue, .green, .pink, .orange, .purple, .mint, .cyan, .indigo]
        confettiPieces = (0..<30).map { i in
            // Blast outward from bottom-right corner in all upward/left directions
            let angle = Double.random(in: 0.4...2.8) // radians, spreading up and left
            let distance = CGFloat.random(in: 100...300)
            return ConfettiPiece(
                id: i,
                color: colors[i % colors.count],
                size: CGFloat.random(in: 16...28),
                endX: 175 - cos(angle) * distance,
                endY: 230 - sin(angle) * distance,
                rotation: Double.random(in: -540...540),
                duration: Double.random(in: 3.0...4.0),
                delay: Double.random(in: 0...0.8)
            )
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: Int
    let color: Color
    let size: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let rotation: Double
    let duration: Double
    let delay: Double
}
