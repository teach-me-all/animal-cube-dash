import SwiftUI

/// A SwiftUI view that renders a preview of an animal cube skin
struct SkinPreviewCube: View {
    let skin: AnimalSkin

    var body: some View {
        ZStack {
            // Body
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(skin.bodyColor))
                .frame(width: 36, height: 36)

            // Eyes
            HStack(spacing: 6) {
                eyeView
                eyeView
            }
            .offset(y: -3)

            // Nose
            Circle()
                .fill(Color(skin.accentColor))
                .frame(width: 4, height: 4)
                .offset(y: 2)

            // Blush
            HStack(spacing: 18) {
                Ellipse()
                    .fill(Color.pink.opacity(0.4))
                    .frame(width: 6, height: 3)
                Ellipse()
                    .fill(Color.pink.opacity(0.4))
                    .frame(width: 6, height: 3)
            }
            .offset(y: 1)

            // Ears
            earView
        }
        .frame(width: 50, height: 50)
    }

    private var eyeView: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
            Circle()
                .fill(Color(red: 0.17, green: 0.2, blue: 0.21))
                .frame(width: 7, height: 7)
            Circle()
                .fill(Color.white)
                .frame(width: 2.5, height: 2.5)
                .offset(x: 1, y: -1)
        }
    }

    @ViewBuilder
    private var earView: some View {
        switch skin.earStyle {
        case .pointed, .sanrioBow, .sanrioJester:
            HStack(spacing: 22) {
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 10)
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 10)
            }
            .offset(y: -22)
        case .round, .sanrioBeret:
            HStack(spacing: 24) {
                Circle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 10)
            }
            .offset(y: -19)
        case .tall, .sanrioHood:
            HStack(spacing: 18) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(skin.bodyColor))
                    .frame(width: 7, height: 16)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(skin.bodyColor))
                    .frame(width: 7, height: 16)
            }
            .offset(y: -24)
        case .floppy:
            HStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(skin.accentColor))
                    .frame(width: 7, height: 10)
                    .rotationEffect(.degrees(-15))
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(skin.accentColor))
                    .frame(width: 7, height: 10)
                    .rotationEffect(.degrees(15))
            }
            .offset(y: -16)
        case .horn:
            HStack(spacing: 16) {
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 8, height: 14)
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 8, height: 14)
            }
            .offset(y: -24)
        case .tuft:
            HStack(spacing: 20) {
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 8)
                Triangle()
                    .fill(Color(skin.accentColor))
                    .frame(width: 10, height: 8)
            }
            .offset(y: -20)
        case .antler:
            HStack(spacing: 20) {
                antlerShape
                antlerShape.scaleEffect(x: -1)
            }
            .offset(y: -24)
        case .none:
            EmptyView()
        }
    }

    private var antlerShape: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 1)
                .fill(Color(skin.accentColor))
                .frame(width: 2, height: 12)
        }
    }
}

/// Simple triangle shape for ears
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}
