import SwiftUI

struct GameOverView: View {
    let level: Int
    let onRetry: () -> Void
    let onHome: () -> Void

    @State private var message = ""
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 6) {
            Text("GAME OVER")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(.red)
                .scaleEffect(appeared ? 1.0 : 0.5)
                .opacity(appeared ? 1.0 : 0)

            Text(message)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: onRetry) {
                Text("Try Again")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange)
                    )
            }
            .buttonStyle(.plain)

            Button(action: onHome) {
                Text("Home")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.red.opacity(0.3), lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 12)
        .onAppear {
            message = BragMessageGenerator.encouragingMessage()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                appeared = true
            }
        }
    }
}
