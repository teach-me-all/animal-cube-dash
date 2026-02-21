import Foundation

class AppUpdateChecker: ObservableObject {
    static let shared = AppUpdateChecker()

    @Published var updateAvailable = false
    @Published var latestVersion: String?

    private var hasChecked = false

    func checkForUpdate() {
        guard !hasChecked else { return }
        hasChecked = true

        guard let bundleId = Bundle.main.bundleIdentifier else { return }
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let first = results.first,
                  let storeVersion = first["version"] as? String else { return }

            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"

            if storeVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                DispatchQueue.main.async {
                    self?.latestVersion = storeVersion
                    self?.updateAvailable = true
                }
            }
        }.resume()
    }
}
