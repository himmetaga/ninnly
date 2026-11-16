import SwiftUI

/// Ninnly uygulama giriş noktası.
@main
struct NinnlyApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(themeManager)
        }
    }
}
