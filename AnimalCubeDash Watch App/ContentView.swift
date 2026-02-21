import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: GameProgressStore

    var body: some View {
        NavigationStack {
            HomeScreenView()
        }
    }
}
