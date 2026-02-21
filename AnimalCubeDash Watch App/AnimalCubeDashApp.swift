import SwiftUI

@main
struct AnimalCubeDashApp: App {
    @StateObject private var store = GameProgressStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .onAppear {
                    GameCenterManager.shared.authenticate()
                }
        }
    }
}
