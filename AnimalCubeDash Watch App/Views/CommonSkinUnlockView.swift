import SwiftUI

struct CommonSkinUnlockView: View {
    let skin: AnimalSkin
    let onDismiss: () -> Void

    @State private var spinAngle: Double = 0
    @State private var showText = false
    @State private var showButton = false
    @State private var bgOpacity: Double = 0

    var body: some View {
        ZStack {
            // Light blue background
            Color(red: 0.6, green: 0.85, blue: 1.0).opacity(bgOpacity)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Spacer()

                // Spinning actual cube
                SkinPreviewCube(skin: skin)
                    .rotation3DEffect(
                        .degrees(spinAngle),
                        axis: (x: 0, y: 1, z: 0)
                    )

                // Skin name
                if showText {
                    Text(skin.displayName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .transition(.opacity)

                    // "COMMON SKIN UNLOCKED!" in cool gradient
                    Text("COMMON SKIN UNLOCKED!")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue, .purple, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.6), radius: 6)
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                if showButton {
                    Button {
                        onDismiss()
                    } label: {
                        Text("Cool!")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [.cyan, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 30)
                    .transition(.opacity)
                }
            }
            .padding(.vertical, 10)
        }
        .onAppear {
            // Fade in blue background
            withAnimation(.easeIn(duration: 0.3)) {
                bgOpacity = 0.85
            }

            // Spin twice (720 degrees)
            withAnimation(.easeInOut(duration: 1.5)) {
                spinAngle = 720
            }

            // Show text after spin completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    showText = true
                }
            }

            // Show button shortly after text
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeIn(duration: 0.3)) {
                    showButton = true
                }
            }
        }
    }
}
