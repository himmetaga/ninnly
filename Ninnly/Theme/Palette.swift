import SwiftUI

/// Gece ve gündüz fazları için renk paleti.
/// Gece fazında beyaz ve mavi ton kullanılmaz.
struct NinnlyPalette: Sendable, Equatable {
    let background: Color
    let surface: Color
    let textPrimary: Color
    let textSecondary: Color
    let feeding: Color
    let sleep: Color

    /// Gece fazı paleti (mavi ve saf beyaz içermez).
    static let night = NinnlyPalette(
        background: Color(hex: 0x050507),
        surface: Color(hex: 0x120E0C),
        textPrimary: Color(hex: 0xF2E3D5),
        textSecondary: Color(hex: 0x9E8274),
        feeding: Color(hex: 0xE86F52),
        sleep: Color(hex: 0xD98A3C)
    )

    /// Gündüz fazı paleti.
    static let day = NinnlyPalette(
        background: Color(hex: 0xFAF6F0),
        surface: Color(hex: 0xE6DFD5),
        textPrimary: Color(hex: 0x231F1E),
        textSecondary: Color(hex: 0x7A6F67),
        feeding: Color(hex: 0xE07A5F),
        sleep: Color(hex: 0x4A7C6F)
    )
}

extension Color {
    /// 24-bit onaltılık (0xRRGGBB) tam sayıdan sRGB renk oluşturur.
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
