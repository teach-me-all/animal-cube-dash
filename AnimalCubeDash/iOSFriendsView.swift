import SwiftUI
import PhotosUI

// MARK: - Profile photo helpers

private let profilePhotoURL: URL = {
    FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("profilePhoto.jpg")
}()

private func saveProfilePhoto(_ image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return }
    try? data.write(to: profilePhotoURL)
}

private func loadProfilePhoto() -> UIImage? {
    guard let data = try? Data(contentsOf: profilePhotoURL) else { return nil }
    return UIImage(data: data)
}

// MARK: - View

struct iOSFriendsView: View {
    @EnvironmentObject var store: iOSProgressStore
    @EnvironmentObject var connectivity: PhoneConnectivityManager
    @State private var showShareSheet = false
    @State private var shareText = ""
    @State private var showNameEditor = false
    @AppStorage("playerName") private var playerName = ""
    @State private var profileImage: UIImage? = loadProfilePhoto()
    @State private var photoPickerItem: PhotosPickerItem? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.14).ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        profileCard
                        syncStatusBanner
                        bragSection
                        inviteSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Friends")
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [shareText])
            }
            .sheet(isPresented: $showNameEditor) {
                NameEditorSheet(playerName: $playerName)
            }
        }
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Your Profile", systemImage: "person.circle.fill")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            HStack(spacing: 14) {
                // Avatar — tapping opens photo picker
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let img = profileImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Text(playerName.isEmpty ? "👤" : String(playerName.prefix(1)).uppercased())
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .background(Circle().fill(Color.green.opacity(0.25)))

                        // Camera badge
                        Image(systemName: "camera.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Circle().fill(Color.green))
                            .offset(x: 2, y: 2)
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: photoPickerItem) { _, item in
                    Task {
                        guard let item,
                              let data = try? await item.loadTransferable(type: Data.self),
                              let uiImage = UIImage(data: data) else { return }
                        // Resize to max 200pt to keep storage small
                        let size = CGSize(width: 200, height: 200)
                        let renderer = UIGraphicsImageRenderer(size: size)
                        let resized = renderer.image { _ in
                            uiImage.draw(in: CGRect(origin: .zero, size: size))
                        }
                        saveProfilePhoto(resized)
                        profileImage = resized
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(playerName.isEmpty ? "No name set" : playerName)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(playerName.isEmpty ? .secondary : .white)
                    Text("Tap photo to change")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            Button {
                showNameEditor = true
            } label: {
                Label("Change Your Name", systemImage: "pencil")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.13, green: 0.16, blue: 0.22)))
    }

    private var syncStatusBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: connectivity.isWatchReachable ? "applewatch" : "applewatch.slash")
                .font(.system(size: 16))
                .foregroundColor(connectivity.isWatchReachable ? .green : .secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(connectivity.isWatchReachable ? "Watch Connected" : "Watch Not Reachable")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                if let date = store.lastSyncDate {
                    Text("Last sync: \(date.formatted(.relative(presentation: .named)))")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.secondary)
                } else {
                    Text("Play on Watch to sync progress")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.13, green: 0.16, blue: 0.22))
        )
    }

    private var bragSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Share Your Achievement", systemImage: "megaphone.fill")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            let msg = bragMessage
            Text(msg)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.primary)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )

            Button {
                shareText = bragMessage
                showShareSheet = true
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.13, green: 0.16, blue: 0.22)))
    }

    private var inviteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Invite Friends", systemImage: "person.badge.plus")
                .font(.system(size: 16, weight: .bold, design: .rounded))

            Text("Challenge your friends to beat your score in Animal Cube Dash on Apple Watch!")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.secondary)

            Button {
                shareText = "Play Animal Cube Dash with me on Apple Watch and iPhone! 🐾 It's free — download it here 👇\n\(appStoreLink)"
                showShareSheet = true
            } label: {
                Label("Invite", systemImage: "envelope.fill")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.13, green: 0.16, blue: 0.22)))
    }

    private let appStoreLink = "https://apps.apple.com/us/app/animal-cube-dash/id6759482553"

    private var bragMessage: String {
        let level = store.highestLevel
        let total = store.totalLevelsCompleted
        let skinCount = store.unlockedSkins.count
        let perfect = store.consecutivePerfectLevels

        let base: String
        if perfect >= 5 {
            base = "I just unlocked a LEGENDARY skin in Animal Cube Dash with \(perfect) perfect levels in a row! 🏆🔥\n\nHighest Level: \(level) | Levels Completed: \(total) | Skins: \(skinCount)/\(AnimalSkin.allCases.count)"
        } else if skinCount == AnimalSkin.allCases.count {
            base = "I collected ALL \(AnimalSkin.allCases.count) skins in Animal Cube Dash! True champion status! 👑\n\nHighest Level: \(level) | Levels Completed: \(total)"
        } else if total >= 100 {
            base = "Over \(total) levels completed in Animal Cube Dash! Can you keep up? 💪🎮\n\nHighest Level: \(level) | Skins Unlocked: \(skinCount)/\(AnimalSkin.allCases.count)"
        } else {
            base = "I just beat Level \(level) in Animal Cube Dash! \(total) levels completed so far — think you can make it this far? 🎉\n\nSkins Unlocked: \(skinCount)/\(AnimalSkin.allCases.count)"
        }
        return "\(base)\n\nDownload Animal Cube Dash 👇\n\(appStoreLink)"
    }
}

private struct NameEditorSheet: View {
    @Binding var playerName: String
    @Environment(\.dismiss) private var dismiss
    @State private var draft = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.08, green: 0.10, blue: 0.14).ignoresSafeArea()
                VStack(spacing: 24) {
                    Text("What should we call you?")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    TextField("Enter your name", text: $draft)
                        .font(.system(size: 17, design: .rounded))
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.13, green: 0.16, blue: 0.22))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.green.opacity(0.4), lineWidth: 1))
                        )
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                        .onSubmit { save() }

                    Button(action: save) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
                    }
                    .buttonStyle(.plain)
                    .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(draft.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.secondary)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear { draft = playerName }
    }

    private func save() {
        let trimmed = draft.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        playerName = trimmed
        dismiss()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
