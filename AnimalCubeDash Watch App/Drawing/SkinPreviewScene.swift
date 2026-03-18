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

            if skin.rarity == .legendary {
                sanrioFace
            } else {
                standardFace
            }

            // Ears
            earView
        }
        .frame(width: 50, height: 50)
    }

    // MARK: - Standard kawaii face

    private var standardFace: some View {
        ZStack {
            HStack(spacing: 6) { eyeView; eyeView }
                .offset(y: -3)
            Circle()
                .fill(Color(skin.accentColor))
                .frame(width: 4, height: 4)
                .offset(y: 2)
            HStack(spacing: 18) {
                Ellipse().fill(Color.pink.opacity(0.4)).frame(width: 6, height: 3)
                Ellipse().fill(Color.pink.opacity(0.4)).frame(width: 6, height: 3)
            }
            .offset(y: 1)
        }
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

    // MARK: - Sanrio character faces

    @ViewBuilder
    private var sanrioFace: some View {
        switch skin {
        case .helloKitty:
            ZStack {
                // Horizontal ovals (wider than tall) + whiskers
                HStack(spacing: 6) {
                    Ellipse().fill(Color.black).frame(width: 8, height: 4)
                    Ellipse().fill(Color.black).frame(width: 8, height: 4)
                }
                .offset(y: -4)
                Canvas { ctx, size in
                    let whiskerYs: [CGFloat] = [12, 15, 18]
                    for (i, wy) in whiskerYs.enumerated() {
                        let curve = wy + CGFloat(i) * 0.3
                        let lPath = Path { p in
                            p.move(to: CGPoint(x: 2, y: wy))
                            p.addLine(to: CGPoint(x: 11, y: curve))
                        }
                        let rPath = Path { p in
                            p.move(to: CGPoint(x: 25, y: curve))
                            p.addLine(to: CGPoint(x: 34, y: wy))
                        }
                        ctx.stroke(lPath, with: .color(Color(white: 0.45)), style: StrokeStyle(lineWidth: 0.7, lineCap: .round))
                        ctx.stroke(rPath, with: .color(Color(white: 0.45)), style: StrokeStyle(lineWidth: 0.7, lineCap: .round))
                    }
                }
                .frame(width: 36, height: 36)
                watchCheeks
            }
        case .myMelody:
            ZStack {
                // Tiny solid dot eyes (no whites), yellow nose
                HStack(spacing: 8) {
                    Circle().fill(Color.black).frame(width: 5, height: 5)
                    Circle().fill(Color.black).frame(width: 5, height: 5)
                }.offset(y: -3)
                Ellipse().fill(Color(red: 1, green: 0.843, blue: 0)).frame(width: 4, height: 3).offset(y: 2)
                watchCheeks
            }
        case .cinnamoroll:
            ZStack {
                HStack(spacing: 2) { cinnamorollEyeWatch; cinnamorollEyeWatch }.offset(y: -2)
                watchCheeks
            }
        case .kuromi:
            ZStack {
                // White face oval patch
                Ellipse().fill(Color.white).frame(width: 26, height: 24).offset(y: 1)
                // Furrowed brows: outer high, inner low
                Canvas { ctx, size in
                    let lPath = Path { p in p.move(to: CGPoint(x: 2, y: 5)); p.addLine(to: CGPoint(x: 14, y: 8)) }
                    let rPath = Path { p in p.move(to: CGPoint(x: 22, y: 8)); p.addLine(to: CGPoint(x: 34, y: 5)) }
                    ctx.stroke(lPath, with: .color(.black), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
                    ctx.stroke(rPath, with: .color(.black), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
                }
                .frame(width: 36, height: 12).offset(y: -11)
                HStack(spacing: 6) { kuromiEyeWatch; kuromiEyeWatch }.offset(y: -3)
                Circle().fill(Color(red: 0.81, green: 0.58, blue: 0.85)).frame(width: 3, height: 3).offset(y: 2)
                // Small fang
                Canvas { ctx, size in
                    let fang = Path { p in
                        p.move(to: CGPoint(x: 16, y: 7)); p.addLine(to: CGPoint(x: 13, y: 12)); p.addLine(to: CGPoint(x: 19, y: 10)); p.closeSubpath()
                    }
                    ctx.fill(fang, with: .color(.white))
                }
                .frame(width: 36, height: 18).offset(y: 5)
            }
        case .pompompurin:
            ZStack {
                // Downward arc eyes (closed/sleepy — NOT open ovals)
                Canvas { ctx, size in
                    let leftEye = Path { p in
                        p.move(to: CGPoint(x: 7, y: 12))
                        p.addQuadCurve(to: CGPoint(x: 16, y: 12), control: CGPoint(x: 11.5, y: 16))
                    }
                    let rightEye = Path { p in
                        p.move(to: CGPoint(x: 20, y: 12))
                        p.addQuadCurve(to: CGPoint(x: 29, y: 12), control: CGPoint(x: 24.5, y: 16))
                    }
                    let style = StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    ctx.stroke(leftEye, with: .color(Color(red: 0.36, green: 0.25, blue: 0.22)), style: style)
                    ctx.stroke(rightEye, with: .color(Color(red: 0.36, green: 0.25, blue: 0.22)), style: style)
                }
                .frame(width: 36, height: 36)
                Circle().fill(Color(red: 0.55, green: 0.43, blue: 0.39)).frame(width: 4, height: 4).offset(y: 4)
                watchCheeks
            }
        case .keroppi:
            ZStack {
                HStack(spacing: 1) { keroppiiEyeWatch; keroppiiEyeWatch }.offset(y: -1)
                // V-shaped mouth
                Canvas { ctx, size in
                    let path = Path { p in
                        p.move(to: CGPoint(x: 7, y: 4))
                        p.addLine(to: CGPoint(x: 18, y: 11))
                        p.addLine(to: CGPoint(x: 29, y: 4))
                    }
                    ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                }
                .frame(width: 36, height: 14)
                .offset(y: 10)
            }
        case .pochacco:
            ZStack {
                // Ink spot on forehead
                Circle().fill(Color.black).frame(width: 7, height: 7).offset(y: -12)
                HStack(spacing: 10) {
                    Circle().fill(Color.black).frame(width: 6, height: 6)
                    Circle().fill(Color.black).frame(width: 6, height: 6)
                }
                .offset(y: -3)
                watchCheeks
                // No mouth — Pochacco has no mouth
            }
        case .badtzMaru:
            ZStack {
                // White belly oval
                Ellipse().fill(Color.white).frame(width: 22, height: 20).offset(y: 4)
                // 4 spiky hair on top
                Canvas { ctx, size in
                    let spikes: [(CGFloat, CGFloat)] = [(5, 3), (12, 0), (22, 1), (30, 4)]
                    for (midX, tipY) in spikes {
                        let spike = Path { p in
                            p.move(to: CGPoint(x: midX, y: tipY))
                            p.addLine(to: CGPoint(x: midX - 3.5, y: 9))
                            p.addLine(to: CGPoint(x: midX + 3.5, y: 9))
                            p.closeSubpath()
                        }
                        ctx.fill(spike, with: .color(.black))
                    }
                }
                .frame(width: 36, height: 9).offset(y: -22)
                // Angry brows
                Canvas { ctx, size in
                    let lPath = Path { p in p.move(to: CGPoint(x: 2, y: 4)); p.addLine(to: CGPoint(x: 15, y: 7)) }
                    let rPath = Path { p in p.move(to: CGPoint(x: 21, y: 7)); p.addLine(to: CGPoint(x: 34, y: 4)) }
                    ctx.stroke(lPath, with: .color(.black), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    ctx.stroke(rPath, with: .color(.black), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                }
                .frame(width: 36, height: 12).offset(y: -11)
                HStack(spacing: 5) { badtzMaruEyeWatch; badtzMaruEyeWatch }.offset(y: -3)
                Triangle().fill(Color(red: 1, green: 0.655, blue: 0.149)).frame(width: 9, height: 6).offset(y: 3)
            }
        case .tuxedoSam:
            ZStack {
                // White belly oval
                Ellipse().fill(Color.white).frame(width: 22, height: 20).offset(y: 4)
                HStack(spacing: 6) { eyeView; eyeView }.offset(y: -4)
                // RED bow tie (not blue!)
                ZStack {
                    HStack(spacing: 0) {
                        Triangle().fill(Color(red: 0.898, green: 0.224, blue: 0.208)).frame(width: 7, height: 6).scaleEffect(x: -1)
                        Triangle().fill(Color(red: 0.898, green: 0.224, blue: 0.208)).frame(width: 7, height: 6)
                    }
                    Circle().fill(Color(red: 0.898, green: 0.224, blue: 0.208)).frame(width: 4, height: 4)
                }
                .offset(y: 11)
                watchCheeks
            }
        case .littleTwinStars:
            let lalaPink = Color(red: 0.957, green: 0.561, blue: 0.694)
            ZStack {
                // Pink hair (Lala)
                HStack(spacing: 0) {
                    Ellipse().fill(lalaPink).frame(width: 9, height: 7)
                    Ellipse().fill(lalaPink).frame(width: 11, height: 8)
                    Ellipse().fill(lalaPink).frame(width: 9, height: 7)
                }
                .offset(y: -20)
                HStack(spacing: 8) {
                    WatchStar().fill(lalaPink).frame(width: 9, height: 9)
                    WatchStar().fill(lalaPink).frame(width: 9, height: 9)
                }
                .offset(y: -4)
                watchCheeks
            }
        case .blueTwinStar:
            let kikiBlue = Color(red: 0.259, green: 0.647, blue: 0.961)
            ZStack {
                // Blue hair (Kiki)
                HStack(spacing: 0) {
                    Ellipse().fill(kikiBlue).frame(width: 9, height: 7)
                    Ellipse().fill(kikiBlue).frame(width: 11, height: 8)
                    Ellipse().fill(kikiBlue).frame(width: 9, height: 7)
                }
                .offset(y: -20)
                HStack(spacing: 8) {
                    WatchStar().fill(kikiBlue).frame(width: 9, height: 9)
                    WatchStar().fill(kikiBlue).frame(width: 9, height: 9)
                }
                .offset(y: -4)
                watchCheeks
            }
        default:
            standardFace
        }
    }

    // MARK: - Sanrio eye helpers

    private var cinnamorollEyeWatch: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 13, height: 13)
            Circle().fill(Color(red: 0.392, green: 0.710, blue: 0.965)).frame(width: 9, height: 9) // sky blue
            Circle().fill(Color(red: 0.082, green: 0.396, blue: 0.753)).frame(width: 5, height: 5) // deeper blue
            Circle().fill(Color.white).frame(width: 2, height: 2).offset(x: 1.5, y: -1.5)
        }
    }

    private var kuromiEyeWatch: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 10, height: 10)
            Circle().fill(Color(red: 0.482, green: 0.122, blue: 0.635)).frame(width: 7, height: 7)
            Circle().fill(Color.white).frame(width: 2.5, height: 2.5).offset(x: 1, y: -1)
        }
    }

    private var pompompurinEyeWatch: some View {
        ZStack {
            Ellipse().fill(Color.white).frame(width: 11, height: 10)
            Circle().fill(Color.black).frame(width: 6, height: 6)
            Circle().fill(Color.white).frame(width: 2, height: 2).offset(x: 1, y: -1)
            Rectangle().fill(Color(red: 0.55, green: 0.43, blue: 0.39)).frame(width: 9, height: 1).offset(y: 1)
        }
    }

    private var keroppiiEyeWatch: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 14, height: 14)
            // Pupil sits HIGH — white crescent visible at bottom
            Circle().fill(Color.black).frame(width: 9, height: 9).offset(y: -2)
            Circle().fill(Color.white).frame(width: 3, height: 3).offset(x: 1.5, y: -3.5)
        }
    }

    private var badtzMaruEyeWatch: some View {
        ZStack {
            Ellipse().fill(Color.white).frame(width: 10, height: 10)
            // Pupil at top of white (half-lidded mean expression)
            Circle().fill(Color.black).frame(width: 6, height: 6).offset(y: -1.5)
            Circle().fill(Color.white).frame(width: 2, height: 2).offset(x: 1, y: -2.5)
        }
    }

    private var watchCheeks: some View {
        HStack(spacing: 18) {
            Ellipse().fill(Color.pink.opacity(0.45)).frame(width: 6, height: 3)
            Ellipse().fill(Color.pink.opacity(0.45)).frame(width: 6, height: 3)
        }
        .offset(y: 1)
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

/// 5-pointed star shape used for LittleTwinStars / BlueTwinStar eyes
private struct WatchStar: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.4
        let step = CGFloat.pi / 5
        return Path { p in
            for i in 0..<10 {
                let r = i.isMultiple(of: 2) ? outer : inner
                let a = CGFloat(i) * step - .pi / 2
                let pt = CGPoint(x: center.x + r * cos(a), y: center.y + r * sin(a))
                if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
            }
            p.closeSubpath()
        }
    }
}
