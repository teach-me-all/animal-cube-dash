import SwiftUI

@main
struct AnimalCubeDashiOSApp: App {
    @StateObject private var progressStore = iOSProgressStore.shared
    @StateObject private var connectivityManager = PhoneConnectivityManager.shared

    init() {
        AdManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            iOSHomeView()
                .environmentObject(progressStore)
                .environmentObject(connectivityManager)
        }
    }
}
