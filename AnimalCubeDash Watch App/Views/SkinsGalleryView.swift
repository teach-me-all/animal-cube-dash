import SwiftUI

struct SkinsGalleryView: View {
    @EnvironmentObject var store: GameProgressStore
    @State private var detailSkin: AnimalSkin? = nil

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(SkinRarity.allCases, id: \.self) { rarity in
                    raritySection(rarity)
                }
            }
            .padding(.horizontal, 6)
        }
        .navigationTitle("Skins")
        .sheet(isPresented: Binding(
            get: { detailSkin != nil },
            set: { if !$0 { detailSkin = nil } }
        )) {
            if let skin = detailSkin {
                WatchSkinDetailView(
                    skin: skin,
                    isUnlocked: store.unlockedSkins.contains(skin),
                    isEquipped: store.selectedSkin == skin
                ) {
                    store.selectedSkin = skin
                    detailSkin = nil
                }
            }
        }
    }

    @ViewBuilder
    private func raritySection(_ rarity: SkinRarity) -> some View {
        let skins = AnimalSkin.skinsByRarity(rarity)

        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color(rarity.color))
                    .frame(width: 6, height: 6)
                Text(rarity.displayName)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(Color(rarity.color))
                Spacer()
                Text("\(skins.filter { store.unlockedSkins.contains($0) }.count)/\(skins.count)")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)

            Text({
                switch rarity {
                case .epic: return "Perfect streak of 10 to earn"
                case .legendary: return "Win a 7-day competition to earn"
                default: return "Complete 10 levels to earn"
                }
            }())
                .font(.system(size: 8, weight: .medium, design: .rounded))
                .foregroundColor(Color(rarity.color).opacity(0.7))
                .padding(.horizontal, 4)

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(skins, id: \.self) { skin in
                    skinCard(skin: skin)
                }
            }
        }
    }

    @ViewBuilder
    private func skinCard(skin: AnimalSkin) -> some View {
        let isUnlocked = store.unlockedSkins.contains(skin)
        let isEquipped = store.selectedSkin == skin

        Button {
            detailSkin = skin
        } label: {
            VStack(spacing: 2) {
                Text(skin.emoji)
                    .font(.system(size: 22))
                    .opacity(isUnlocked ? 1.0 : 0.3)

                Text(skin.displayName)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isEquipped ? Color(skin.rarity.color).opacity(0.3) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEquipped ? Color(skin.rarity.color) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Watch Skin Detail Sheet

private struct WatchSkinDetailView: View {
    let skin: AnimalSkin
    let isUnlocked: Bool
    let isEquipped: Bool
    let onEquip: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.09, blue: 0.13).ignoresSafeArea()

            VStack(spacing: 8) {
                SkinPreviewCube(skin: skin)
                    .scaleEffect(2.2)
                    .opacity(isUnlocked ? 1.0 : 0.3)
                    .padding(.top, 24)
                    .padding(.bottom, 16)

                Text(skin.displayName)
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)

                Text(skin.rarity.displayName.uppercased())
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundColor(Color(skin.rarity.color))
                    .tracking(1.5)

                Spacer()

                if isUnlocked {
                    if isEquipped {
                        Label("Equipped", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(skin.rarity.color))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(skin.rarity.color), lineWidth: 1)
                            )
                    } else {
                        Button(action: onEquip) {
                            Text("Equip")
                                .font(.system(size: 13, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(skin.rarity.color))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Label("Locked", systemImage: "lock.fill")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.06))
                        )
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
    }
}
