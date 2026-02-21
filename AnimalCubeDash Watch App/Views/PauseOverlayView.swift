import SwiftUI

struct PauseOverlayView: View {
    let onResume: () -> Void
    let onRestart: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("PAUSED")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Button(action: onResume) {
                Text("Resume")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)

            Button(action: onRestart) {
                Text("Restart")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.85))
        )
        .padding(.horizontal, 12)
    }
}
