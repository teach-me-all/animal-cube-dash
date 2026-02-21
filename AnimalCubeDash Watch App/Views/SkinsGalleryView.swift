import SwiftUI

struct SkinsGalleryView: View {
    @EnvironmentObject var store: GameProgressStore
    @State private var tappedSkin: AnimalSkin?
    @State private var showBragSheet = false

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
        .sheet(isPresented: $showBragSheet) {
            if let skin = tappedSkin {
                ShareBragView(message: BragMessageGenerator.skinBragMessage(skin: skin))
            }
        }
    }

    @ViewBuilder
    private func raritySection(_ rarity: SkinRarity) -> some View {
        let skins = AnimalSkin.skinsByRarity(rarity)

        VStack(spacing: 6) {
            // Section header
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

            if rarity == .common {
                Text("Complete 10 levels to unlock")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundColor(Color(rarity.color).opacity(0.7))
                    .padding(.horizontal, 4)
            } else if rarity == .legendary {
                Text("Pass 5 levels with no lives lost")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundColor(Color(rarity.color).opacity(0.7))
                    .padding(.horizontal, 4)
            } else {
                Text("Finish a level with 2+ lives to unlock")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundColor(Color(rarity.color).opacity(0.7))
                    .padding(.horizontal, 4)
            }

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
        let isSelected = store.selectedSkin == skin
        let isTapped = tappedSkin == skin

        VStack(spacing: 2) {
            Button {
                if isUnlocked {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        tappedSkin = tappedSkin == skin ? nil : skin
                    }
                }
            } label: {
                VStack(spacing: 2) {
                    Text(skin.emoji)
                        .font(.system(size: 22))
                        .opacity(isUnlocked ? 1.0 : 0.3)

                    Text(skin.displayName)
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(isUnlocked ? .primary : .secondary)
                        .lineLimit(1)

                    if !isUnlocked {
                        Text("Lv \(skin.unlockLevel)")
                            .font(.system(size: 7, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color(skin.rarity.color).opacity(0.3) : isTapped ? Color(skin.rarity.color).opacity(0.15) : Color.gray.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color(skin.rarity.color) : isTapped ? Color(skin.rarity.color).opacity(0.5) : Color.clear, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            .disabled(!isUnlocked)

            // Select & Brag buttons
            if isTapped && isUnlocked {
                HStack(spacing: 4) {
                    Button {
                        store.selectedSkin = skin
                        withAnimation {
                            tappedSkin = nil
                        }
                    } label: {
                        Text("Select")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color(skin.rarity.color))
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        showBragSheet = true
                    } label: {
                        Text("Brag")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.orange)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}
