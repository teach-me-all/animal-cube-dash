import SwiftUI

struct GiftBoxView: View {
    let skin: AnimalSkin
    let onDismiss: () -> Void

    @State private var boxScale: CGFloat = 0.3
    @State private var boxShake = false
    @State private var boxOpened = false
    @State private var skinReveal = false
    @State private var glowPulse = false
    @State private var sparkles = false

    private var rarityColor: Color {
        Color(skin.rarity.color)
    }

    var body: some View {
        ZStack {
            // Light blue background
            Color(red: 0.6, green: 0.85, blue: 1.0)
                .ignoresSafeArea()

            if !boxOpened {
                // Gift box - tap to open
                VStack(spacing: 4) {
                    Text("You earned a gift!")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    // Gift box
                    ZStack {
                        // Box body
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [rarityColor, rarityColor.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 60, height: 50)

                        // Ribbon vertical
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 8, height: 50)

                        // Ribbon horizontal
                        Rectangle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 60, height: 8)

                        // Bow on top
                        Text("🎀")
                            .font(.system(size: 20))
                            .offset(y: -28)

                        // Question mark
                        Text("?")
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .scaleEffect(boxScale)
                    .rotationEffect(.degrees(boxShake ? 3 : -3))

                    Text("Tap to open!")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                .onTapGesture {
                    openBox()
                }
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        boxScale = 1.0
                    }
                    withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
                        boxShake = true
                    }
                }
            } else {
                // Skin reveal
                VStack(spacing: 6) {
                    // Rarity label
                    Text(skin.rarity.displayName)
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundColor(rarityColor)
                        .textCase(.uppercase)
                        .opacity(skinReveal ? 1 : 0)

                    // Actual cube with glow
                    ZStack {
                        // Glow circle behind
                        Circle()
                            .fill(rarityColor.opacity(0.3))
                            .frame(width: glowPulse ? 70 : 55, height: glowPulse ? 70 : 55)
                            .blur(radius: 8)

                        Circle()
                            .fill(rarityColor.opacity(0.15))
                            .frame(width: 50, height: 50)

                        SkinPreviewCube(skin: skin)
                    }
                    .scaleEffect(skinReveal ? 1.0 : 0.1)

                    // Skin name
                    Text(skin.displayName)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(skinReveal ? 1 : 0)

                    Text("New skin unlocked!")
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(skinReveal ? 1 : 0)

                    // Sparkle particles
                    if sparkles {
                        HStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { i in
                                Circle()
                                    .fill(rarityColor)
                                    .frame(width: 4, height: 4)
                                    .offset(
                                        x: CGFloat.random(in: -30...30),
                                        y: CGFloat.random(in: -20...10)
                                    )
                                    .opacity(Double.random(in: 0.3...1.0))
                            }
                        }
                        .transition(.opacity)
                    }

                    Button {
                        onDismiss()
                    } label: {
                        Text("Awesome!")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(rarityColor)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 30)
                    .opacity(skinReveal ? 1 : 0)
                }
            }
        }
    }

    private func openBox() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            boxOpened = true
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.1)) {
            skinReveal = true
        }

        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.3)) {
            glowPulse = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                sparkles = true
            }
        }
    }
}
