import SwiftUI

struct iOSSkinsView: View {
    @EnvironmentObject var store: iOSProgressStore
    @State private var detailSkin: AnimalSkin? = nil

    private let rarities: [SkinRarity] = [.legendary, .epic, .ultraRare, .rare, .common]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.14).ignoresSafeArea()
                List {
                    ForEach(rarities, id: \.self) { rarity in
                        let skins = AnimalSkin.allCases.filter { $0.rarity == rarity }
                        Section {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 76))], spacing: 12) {
                                ForEach(skins, id: \.self) { skin in
                                    Button {
                                        detailSkin = skin
                                    } label: {
                                        SkinCell(
                                            skin: skin,
                                            isUnlocked: store.unlockedSkins.contains(skin),
                                            isEquipped: store.selectedSkin == skin
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 8)
                        } header: {
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(rarity.color)
                                        .frame(width: 9, height: 9)
                                    Text(rarity.displayName.uppercased())
                                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                                        .foregroundColor(rarity.color)
                                        .tracking(1)
                                    Spacer()
                                    let unlocked = skins.filter { store.unlockedSkins.contains($0) }.count
                                    Text("\(unlocked)/\(skins.count)")
                                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                Text({
                                    switch rarity {
                                    case .epic: return "Perfect streak of 10 to earn"
                                    case .legendary: return "Win a 7-day competition to earn"
                                    default: return "Complete 10 levels to earn"
                                    }
                                }())
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .foregroundColor(rarity.color.opacity(0.7))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Skins Collection")
            .sheet(isPresented: Binding(
                get: { detailSkin != nil },
                set: { if !$0 { detailSkin = nil } }
            )) {
                if let skin = detailSkin {
                    iOSSkinDetailView(skin: skin, isUnlocked: store.unlockedSkins.contains(skin), isEquipped: store.selectedSkin == skin) {
                        store.selectedSkin = skin
                        detailSkin = nil
                    }
                }
            }
        }
    }
}

struct SkinCell: View {
    let skin: AnimalSkin
    let isUnlocked: Bool
    var isEquipped: Bool = false

    var body: some View {
        VStack(spacing: 5) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(skin.rarity.color.opacity(isEquipped ? 0.35 : isUnlocked ? 0.18 : 0.05))
                    .frame(width: 64, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(skin.rarity.color.opacity(isEquipped ? 1.0 : isUnlocked ? 0.4 : 0.1), lineWidth: isEquipped ? 2 : 1)
                    )

                Text(skin.emoji)
                    .font(.system(size: 30))
                    .opacity(isUnlocked ? 1.0 : 0.25)
                    .frame(width: 64, height: 64)

                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(4)
                } else if isEquipped {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(skin.rarity.color)
                        .padding(3)
                }
            }

            Text(skin.displayName)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

// MARK: - Skin Detail Sheet

private struct iOSSkinDetailView: View {
    let skin: AnimalSkin
    let isUnlocked: Bool
    let isEquipped: Bool
    let onEquip: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var cubeScale: CGFloat = 0.5
    @State private var cubeOpacity: Double = 0

    var body: some View {
        ZStack {
            // Background: dark with rarity colour radial glow
            Color(red: 0.07, green: 0.09, blue: 0.13).ignoresSafeArea()
            RadialGradient(
                colors: [skin.rarity.color.opacity(0.25), .clear],
                center: .center,
                startRadius: 0,
                endRadius: 220
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .buttonStyle(.plain)
                    .padding([.top, .trailing], 20)
                }

                Spacer()

                // Cube preview
                iOSSkinPreviewCube(skin: skin)
                    .scaleEffect(3.0)
                    .opacity(isUnlocked ? 1.0 : 0.3)
                    .scaleEffect(cubeScale)
                    .opacity(cubeOpacity)
                    .padding(.bottom, 40)

                // Name + rarity
                Text(skin.displayName)
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                Text(skin.rarity.displayName.uppercased())
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(skin.rarity.color)
                    .tracking(2)
                    .padding(.top, 4)

                Spacer()

                // Equip / Equipped / Locked button
                if isUnlocked {
                    if isEquipped {
                        Label("Equipped", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(skin.rarity.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(skin.rarity.color.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(skin.rarity.color, lineWidth: 1.5)
                                    )
                            )
                            .padding(.horizontal, 32)
                    } else {
                        Button(action: onEquip) {
                            Text("Equip")
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(skin.rarity.color)
                                )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 32)
                    }
                } else {
                    Label("Locked", systemImage: "lock.fill")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.06))
                        )
                        .padding(.horizontal, 32)
                }

                Spacer().frame(height: 48)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                cubeScale = 1.0
                cubeOpacity = 1.0
            }
        }
    }
}
