import SwiftUI

// MARK: - Skin Preview Cube (iOS-sized)

private struct IOSTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            p.closeSubpath()
        }
    }
}

private struct IOSStar: Shape {
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

struct iOSSkinPreviewCube: View {
    let skin: AnimalSkin

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(skin.bodyColor))
                .frame(width: 58, height: 58)

            if skin.rarity == .legendary {
                sanrioFace
            } else {
                standardFace
            }

            earView
        }
        .frame(width: 80, height: 80)
    }

    // MARK: - Standard kawaii face

    private var standardFace: some View {
        ZStack {
            HStack(spacing: 10) { kawaiiEye; kawaiiEye }
                .offset(y: -5)
            Circle()
                .fill(Color(skin.accentColor))
                .frame(width: 6, height: 6)
                .offset(y: 3)
            HStack(spacing: 29) {
                Ellipse().fill(Color.pink.opacity(0.4)).frame(width: 10, height: 5)
                Ellipse().fill(Color.pink.opacity(0.4)).frame(width: 10, height: 5)
            }
            .offset(y: 2)
        }
    }

    private var kawaiiEye: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 16, height: 16)
            Circle().fill(Color(red: 0.17, green: 0.2, blue: 0.21)).frame(width: 11, height: 11)
            Circle().fill(Color.white).frame(width: 4, height: 4).offset(x: 1.5, y: -1.5)
        }
    }

    // MARK: - Sanrio character faces

    @ViewBuilder
    private var sanrioFace: some View {
        switch skin {
        case .helloKitty:     helloKittyFace
        case .myMelody:       myMelodyFace
        case .cinnamoroll:    cinnamorollFace
        case .kuromi:         kuromiFace
        case .pompompurin:    pompompurinFace
        case .keroppi:        keroppiFace
        case .pochacco:       pochaccoFace
        case .badtzMaru:      badtzMaruFace
        case .tuxedoSam:      tuxedoSamFace
        case .littleTwinStars: twinStarFace(starColor: Color(hex: 0xF48FB1))
        case .blueTwinStar:   twinStarFace(starColor: Color(hex: 0x42A5F5))
        default:              standardFace
        }
    }

    /// Hello Kitty — HORIZONTAL flat oval eyes (wider than tall), 6 whiskers, no mouth
    private var helloKittyFace: some View {
        ZStack {
            HStack(spacing: 10) {
                Ellipse().fill(Color.black).frame(width: 13, height: 7)
                Ellipse().fill(Color.black).frame(width: 13, height: 7)
            }
            .offset(y: -6)
            // 3 whiskers per side (Hello Kitty's most iconic feature)
            Canvas { ctx, size in
                let whiskerYs: [CGFloat] = [18, 23, 28]
                for (i, wy) in whiskerYs.enumerated() {
                    let yCurve = wy + CGFloat(i) * 0.5
                    let lPath = Path { p in
                        p.move(to: CGPoint(x: 5, y: wy))
                        p.addLine(to: CGPoint(x: 20, y: yCurve))
                    }
                    let rPath = Path { p in
                        p.move(to: CGPoint(x: 38, y: yCurve))
                        p.addLine(to: CGPoint(x: 53, y: wy))
                    }
                    ctx.stroke(lPath, with: .color(Color(white: 0.45)), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                    ctx.stroke(rPath, with: .color(Color(white: 0.45)), style: StrokeStyle(lineWidth: 1, lineCap: .round))
                }
            }
            .frame(width: 58, height: 58)
            cheeks
        }
    }

    /// My Melody — tiny solid dot eyes (no whites), yellow nose, no mouth
    private var myMelodyFace: some View {
        ZStack {
            HStack(spacing: 16) {
                Circle().fill(Color.black).frame(width: 8, height: 8)
                Circle().fill(Color.black).frame(width: 8, height: 8)
            }
            .offset(y: -5)
            Ellipse().fill(Color(hex: 0xFFD700)).frame(width: 7, height: 5).offset(y: 3)
            cheeks
        }
    }

    /// Cinnamoroll — very large sky-blue eyes, cinnamon swirl on forehead
    private var cinnamorollFace: some View {
        ZStack {
            // Cinnamon roll swirl on forehead (signature mark)
            Canvas { ctx, size in
                let curl = Path { p in
                    p.move(to: CGPoint(x: 24, y: 8))
                    p.addQuadCurve(to: CGPoint(x: 34, y: 8), control: CGPoint(x: 29, y: 3))
                }
                ctx.stroke(curl, with: .color(Color(hex: 0xFFB6C1)), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            }
            .frame(width: 58, height: 16)
            .offset(y: -22)

            HStack(spacing: 4) {
                cinnamorollEye
                cinnamorollEye
            }
            .offset(y: -3)
            cheeks
        }
    }

    private var cinnamorollEye: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 20, height: 20)
            Circle().fill(Color(hex: 0x64B5F6)).frame(width: 14, height: 14)   // sky blue iris
            Circle().fill(Color(hex: 0x1565C0)).frame(width: 8, height: 8)     // deeper blue pupil
            Circle().fill(Color.white).frame(width: 3, height: 3).offset(x: 2, y: -2)
        }
    }

    /// Kuromi — white face oval on dark body, purple eyes, furrowed brows, fang
    private var kuromiFace: some View {
        ZStack {
            // White face oval (Kuromi's pale face on dark body)
            Ellipse().fill(Color.white).frame(width: 40, height: 36).offset(y: 2)

            // Furrowed eyebrows: outer=high, inner=low (V-shape toward center)
            Canvas { ctx, size in
                let lPath = Path { p in
                    p.move(to: CGPoint(x: 4, y: 8))    // outer left, high
                    p.addLine(to: CGPoint(x: 20, y: 12)) // inner right, low
                }
                let rPath = Path { p in
                    p.move(to: CGPoint(x: 38, y: 12))  // inner left, low
                    p.addLine(to: CGPoint(x: 54, y: 8)) // outer right, high
                }
                ctx.stroke(lPath, with: .color(.black), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                ctx.stroke(rPath, with: .color(.black), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
            }
            .frame(width: 58, height: 18)
            .offset(y: -16)

            HStack(spacing: 10) { kuromiEye; kuromiEye }
                .offset(y: -4)

            Circle().fill(Color(hex: 0xCE93D8)).frame(width: 5, height: 5).offset(y: 4)

            // Small white fang
            Canvas { ctx, size in
                let fang = Path { p in
                    p.move(to: CGPoint(x: 25, y: 12))
                    p.addLine(to: CGPoint(x: 20, y: 20))
                    p.addLine(to: CGPoint(x: 30, y: 16))
                    p.closeSubpath()
                }
                ctx.fill(fang, with: .color(.white))
            }
            .frame(width: 58, height: 28)
            .offset(y: 8)
        }
    }

    private var kuromiEye: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 15, height: 15)
            Circle().fill(Color(hex: 0x7B1FA2)).frame(width: 10, height: 10)
            Circle().fill(Color.white).frame(width: 3.5, height: 3.5).offset(x: 1.5, y: -1.5)
        }
    }

    /// Pompompurin — downward arc closed eyes (sleepy/relaxed), NOT open ovals
    private var pompompurinFace: some View {
        ZStack {
            // Downward arc eyes — the defining feature of Pompompurin's relaxed expression
            Canvas { ctx, size in
                let leftEye = Path { p in
                    p.move(to: CGPoint(x: 10, y: 16))
                    p.addQuadCurve(to: CGPoint(x: 26, y: 16), control: CGPoint(x: 18, y: 24))
                }
                let rightEye = Path { p in
                    p.move(to: CGPoint(x: 32, y: 16))
                    p.addQuadCurve(to: CGPoint(x: 48, y: 16), control: CGPoint(x: 40, y: 24))
                }
                let style = StrokeStyle(lineWidth: 3.5, lineCap: .round)
                ctx.stroke(leftEye, with: .color(Color(red: 0.36, green: 0.25, blue: 0.22)), style: style)
                ctx.stroke(rightEye, with: .color(Color(red: 0.36, green: 0.25, blue: 0.22)), style: style)
            }
            .frame(width: 58, height: 44)
            .offset(y: -8)

            Circle().fill(Color(hex: 0x8D6E63)).frame(width: 6, height: 6).offset(y: 6)
            cheeks
        }
    }

    /// Keroppi — huge round eyes with pupils at top, V-shaped mouth
    private var keroppiFace: some View {
        ZStack {
            HStack(spacing: 2) { keroppiiEye; keroppiiEye }
                .offset(y: -1)
            // V-shaped mouth (two lines meeting at bottom center)
            Canvas { ctx, size in
                let path = Path { p in
                    p.move(to: CGPoint(x: 10, y: 6))
                    p.addLine(to: CGPoint(x: 29, y: 18))
                    p.addLine(to: CGPoint(x: 48, y: 6))
                }
                ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
            .frame(width: 58, height: 22)
            .offset(y: 16)
        }
    }

    private var keroppiiEye: some View {
        ZStack {
            Circle().fill(Color.white).frame(width: 22, height: 22)
            // Pupil sits HIGH — white crescent visible at bottom (Keroppi's look)
            Circle().fill(Color.black).frame(width: 14, height: 14).offset(y: -3)
            Circle().fill(Color.white).frame(width: 5, height: 5).offset(x: 2, y: -5)
        }
    }

    /// Pochacco — tiny dot eyes, ink spot on forehead
    private var pochaccoFace: some View {
        ZStack {
            // Ink spot on forehead
            Circle().fill(Color.black).frame(width: 11, height: 11).offset(y: -20)
            HStack(spacing: 16) {
                pochaccoEye
                pochaccoEye
            }
            .offset(y: -5)
            Circle().fill(Color.black).frame(width: 5, height: 5).offset(y: 3)
            cheeks
        }
    }

    private var pochaccoEye: some View {
        ZStack {
            Circle().fill(Color.black).frame(width: 9, height: 9)
            Circle().fill(Color.white).frame(width: 3, height: 3).offset(x: 1.5, y: -1.5)
        }
    }

    /// Badtz-Maru — white belly, 4 spiky hair, half-lidded pupils at top, grumpy frown
    private var badtzMaruFace: some View {
        ZStack {
            // White belly/chest oval
            Ellipse().fill(Color.white).frame(width: 36, height: 32).offset(y: 8)

            // 4 spiky black hair on top
            Canvas { ctx, size in
                let spikes: [(CGFloat, CGFloat)] = [(8, 6), (19, 2), (32, 3), (44, 7)]
                for (midX, tipY) in spikes {
                    let spike = Path { p in
                        p.move(to: CGPoint(x: midX, y: tipY))
                        p.addLine(to: CGPoint(x: midX - 6, y: 16))
                        p.addLine(to: CGPoint(x: midX + 6, y: 16))
                        p.closeSubpath()
                    }
                    ctx.fill(spike, with: .color(.black))
                }
            }
            .frame(width: 58, height: 16)
            .offset(y: -37)

            // Heavy angry eyebrows (outer high → inner low, furrowed)
            Canvas { ctx, size in
                let lPath = Path { p in
                    p.move(to: CGPoint(x: 5, y: 6))
                    p.addLine(to: CGPoint(x: 24, y: 10))
                }
                let rPath = Path { p in
                    p.move(to: CGPoint(x: 34, y: 10))
                    p.addLine(to: CGPoint(x: 53, y: 6))
                }
                ctx.stroke(lPath, with: .color(.black), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                ctx.stroke(rPath, with: .color(.black), style: StrokeStyle(lineWidth: 3, lineCap: .round))
            }
            .frame(width: 58, height: 16)
            .offset(y: -17)

            HStack(spacing: 8) { badtzMaruEye; badtzMaruEye }
                .offset(y: -4)

            // Orange beak
            IOSTriangle().fill(Color(hex: 0xFFA726)).frame(width: 14, height: 9).offset(y: 5)
        }
    }

    private var badtzMaruEye: some View {
        ZStack {
            Ellipse().fill(Color.white).frame(width: 16, height: 15)
            // Pupil at top (half-lidded mean expression)
            Circle().fill(Color.black).frame(width: 10, height: 10).offset(y: -2.5)
            Circle().fill(Color.white).frame(width: 3.5, height: 3.5).offset(x: 2, y: -4)
        }
    }

    /// Tuxedo Sam — white belly, round eyes, RED bow tie on chest
    private var tuxedoSamFace: some View {
        ZStack {
            // White belly/chest oval
            Ellipse().fill(Color.white).frame(width: 36, height: 32).offset(y: 8)

            HStack(spacing: 10) { kawaiiEye; kawaiiEye }
                .offset(y: -6)
            // RED bow tie (Tuxedo Sam's bow is RED, not blue)
            ZStack {
                HStack(spacing: 0) {
                    IOSTriangle().fill(Color(hex: 0xE53935)).frame(width: 11, height: 9).scaleEffect(x: -1)
                    IOSTriangle().fill(Color(hex: 0xE53935)).frame(width: 11, height: 9)
                }
                Circle().fill(Color(hex: 0xE53935)).frame(width: 6, height: 6)
            }
            .offset(y: 18)
            cheeks
        }
    }

    /// LittleTwinStars (Lala=pink) / BlueTwinStar (Kiki=blue) — colored hair, star eyes, smile
    private func twinStarFace(starColor: Color) -> some View {
        ZStack {
            // Hair on top (Lala = long pink, Kiki = blue bowl cut — shown as hair blobs)
            HStack(spacing: 0) {
                Ellipse().fill(starColor).frame(width: 14, height: 12)
                Ellipse().fill(starColor).frame(width: 18, height: 14)
                Ellipse().fill(starColor).frame(width: 16, height: 13)
                Ellipse().fill(starColor).frame(width: 12, height: 11)
            }
            .offset(y: -33)

            HStack(spacing: 14) {
                IOSStar().fill(starColor).frame(width: 14, height: 14)
                IOSStar().fill(starColor).frame(width: 14, height: 14)
            }
            .offset(y: -6)
            cheeks
            // Happy smile
            Canvas { ctx, size in
                let path = Path { p in
                    p.move(to: CGPoint(x: 16, y: 8))
                    p.addQuadCurve(to: CGPoint(x: 42, y: 8),
                                   control: CGPoint(x: 29, y: 18))
                }
                ctx.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: 1.8, lineCap: .round))
            }
            .frame(width: 58, height: 22)
            .offset(y: 10)
        }
    }

    // MARK: - Shared helpers

    private var cheeks: some View {
        HStack(spacing: 29) {
            Ellipse().fill(Color.pink.opacity(0.45)).frame(width: 10, height: 5)
            Ellipse().fill(Color.pink.opacity(0.45)).frame(width: 10, height: 5)
        }
        .offset(y: 2)
    }

    // MARK: - Ear / headwear

    @ViewBuilder
    private var earView: some View {
        switch skin.earStyle {
        case .pointed, .sanrioBow, .sanrioJester:
            HStack(spacing: 35) {
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 16, height: 16)
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 16, height: 16)
            }
            .offset(y: -35)
        case .round, .sanrioBeret:
            HStack(spacing: 38) {
                Circle().fill(Color(skin.accentColor)).frame(width: 16, height: 16)
                Circle().fill(Color(skin.accentColor)).frame(width: 16, height: 16)
            }
            .offset(y: -30)
        case .tall, .sanrioHood:
            HStack(spacing: 29) {
                RoundedRectangle(cornerRadius: 5).fill(Color(skin.bodyColor)).frame(width: 11, height: 26)
                RoundedRectangle(cornerRadius: 5).fill(Color(skin.bodyColor)).frame(width: 11, height: 26)
            }
            .offset(y: -38)
        case .floppy:
            HStack(spacing: 48) {
                RoundedRectangle(cornerRadius: 5).fill(Color(skin.accentColor)).frame(width: 11, height: 16).rotationEffect(.degrees(-15))
                RoundedRectangle(cornerRadius: 5).fill(Color(skin.accentColor)).frame(width: 11, height: 16).rotationEffect(.degrees(15))
            }
            .offset(y: -26)
        case .horn:
            HStack(spacing: 26) {
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 13, height: 22)
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 13, height: 22)
            }
            .offset(y: -38)
        case .tuft:
            HStack(spacing: 32) {
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 16, height: 13)
                IOSTriangle().fill(Color(skin.accentColor)).frame(width: 16, height: 13)
            }
            .offset(y: -32)
        case .antler:
            HStack(spacing: 32) {
                antlerShape
                antlerShape.scaleEffect(x: -1)
            }
            .offset(y: -38)
        case .none:
            EmptyView()
        }
    }

    private var antlerShape: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(skin.accentColor))
            .frame(width: 3, height: 19)
    }
}

// MARK: - Common / Rare / Ultra Rare Unlock (spin animation)

struct iOSSkinUnlockView: View {
    let skin: AnimalSkin
    let onDismiss: () -> Void

    @State private var spinAngle: Double = 0
    @State private var showText = false
    @State private var showButton = false
    @State private var bgOpacity: Double = 0

    var body: some View {
        ZStack {
            Color(red: 0.6, green: 0.85, blue: 1.0)
                .opacity(bgOpacity)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                iOSSkinPreviewCube(skin: skin)
                    .scaleEffect(1.4)
                    .rotation3DEffect(.degrees(spinAngle), axis: (x: 0, y: 1, z: 0))

                if showText {
                    Text(skin.displayName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .transition(.opacity)

                    Text("\(skin.rarity.displayName) Skin Unlocked!")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue, .purple, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .cyan.opacity(0.6), radius: 8)
                        .multilineTextAlignment(.center)
                        .transition(.scale.combined(with: .opacity))
                }

                Spacer()

                if showButton {
                    Button(action: onDismiss) {
                        Text("Awesome!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(LinearGradient(
                                        colors: [.cyan, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.3)) { bgOpacity = 0.9 }
            withAnimation(.easeInOut(duration: 1.5)) { spinAngle = 720 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { showText = true }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeIn(duration: 0.3)) { showButton = true }
            }
        }
    }
}

// MARK: - Epic / Legendary Gift Box Unlock

struct iOSGiftBoxUnlockView: View {
    let skin: AnimalSkin
    let onDismiss: () -> Void

    @State private var boxScale: CGFloat = 0.3
    @State private var boxShake = false
    @State private var boxOpened = false
    @State private var skinReveal = false
    @State private var glowPulse = false
    @State private var sparkles = false

    private var rarityColor: Color { skin.rarity.color }

    var body: some View {
        ZStack {
            Color(red: 0.6, green: 0.85, blue: 1.0).ignoresSafeArea()

            if !boxOpened {
                VStack(spacing: 16) {
                    Text("You earned a gift!")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(LinearGradient(
                                colors: [rarityColor, rarityColor.opacity(0.7)],
                                startPoint: .top, endPoint: .bottom
                            ))
                            .frame(width: 120, height: 100)
                        Rectangle().fill(Color.white.opacity(0.4)).frame(width: 16, height: 100)
                        Rectangle().fill(Color.white.opacity(0.4)).frame(width: 120, height: 16)
                        Text("🎀").font(.system(size: 40)).offset(y: -56)
                        Text("?")
                            .font(.system(size: 48, weight: .heavy, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .scaleEffect(boxScale)
                    .rotationEffect(.degrees(boxShake ? 3 : -3))

                    Text("Tap to open!")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                }
                .onTapGesture { openBox() }
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) { boxScale = 1.0 }
                    withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) { boxShake = true }
                }
            } else {
                VStack(spacing: 14) {
                    Text(skin.rarity.displayName.uppercased())
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .foregroundColor(rarityColor)
                        .opacity(skinReveal ? 1 : 0)

                    ZStack {
                        Circle()
                            .fill(rarityColor.opacity(0.3))
                            .frame(
                                width: glowPulse ? 140 : 110,
                                height: glowPulse ? 140 : 110
                            )
                            .blur(radius: 16)
                        Circle().fill(rarityColor.opacity(0.15)).frame(width: 100, height: 100)
                        iOSSkinPreviewCube(skin: skin)
                    }
                    .scaleEffect(skinReveal ? 1.0 : 0.1)

                    Text(skin.displayName)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(skinReveal ? 1 : 0)

                    Text("\(skin.rarity.displayName) Skin Unlocked!")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                        .opacity(skinReveal ? 1 : 0)

                    if sparkles {
                        HStack(spacing: 20) {
                            ForEach(0..<5, id: \.self) { _ in
                                Circle()
                                    .fill(rarityColor)
                                    .frame(width: 8, height: 8)
                                    .offset(
                                        x: CGFloat.random(in: -50...50),
                                        y: CGFloat.random(in: -30...20)
                                    )
                                    .opacity(Double.random(in: 0.3...1.0))
                            }
                        }
                        .transition(.opacity)
                    }

                    Button(action: onDismiss) {
                        Text("Awesome!")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 14).fill(rarityColor))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 40)
                    .opacity(skinReveal ? 1 : 0)
                }
            }
        }
    }

    private func openBox() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) { boxOpened = true }
        withAnimation(.spring(response: 0.6, dampingFraction: 0.5).delay(0.1)) { skinReveal = true }
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(0.3)) { glowPulse = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation { sparkles = true }
        }
    }
}

// MARK: - Color hex helper

extension Color {
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
