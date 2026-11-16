import NinnlyCore
import SwiftUI

/// A0 aşaması ana ekran iskeleti.
/// Kutusuz tasarım: kart, çerçeve veya gölge kullanılmaz; yalnız yüzen tipografi yer alır.
struct RootView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        let palette = themeManager.palette

        ZStack {
            palette.background
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                Text("Ninnly")
                    .font(.system(size: 48, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.textPrimary)
                    .accessibilityIdentifier("home.wordmark")

                Text("home.subtitle")
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(palette.textSecondary)
                    .multilineTextAlignment(.center)

                Spacer()

                Text(themeManager.phase == .night ? LocalizedStringKey("phase.night") : LocalizedStringKey("phase.day"))
                    .font(.system(.footnote, design: .rounded).weight(.medium))
                    .foregroundStyle(palette.sleep)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(themeManager.phase == .night ? .dark : .light)
    }
}

#Preview("Gece") {
    RootView()
        .environmentObject(ThemeManager(arguments: ["-ninnlyPhase", "night"]))
}

#Preview("Gündüz") {
    RootView()
        .environmentObject(ThemeManager(arguments: ["-ninnlyPhase", "day"]))
}
