import Foundation

/// Emzirme veya sağım yapılan göğüs yönü.
public enum BreastSide: String, Sendable, CaseIterable {
    case left
    case right

    /// Karşı göğüs yönünü döndürür.
    public var opposite: BreastSide {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}

/// Tek bir emzirme oturumu kaydı.
public struct BreastSession: Sendable, Equatable {
    public let side: BreastSide
    public let start: Date
    public let end: Date

    public init(side: BreastSide, start: Date, end: Date) {
        self.side = side
        self.start = start
        self.end = end
    }
}

/// Son emzirilen göğsü, sıradaki öneriyi ve sağ/sol süre dengesini hesaplayan yardımcı.
public enum BreastSideAdvisor {
    /// En son sona eren oturumun göğüs yönünü döndürür.
    /// Bitiş zamanları eşitse daha geç başlayan oturum tercih edilir; liste boşsa `nil` döner.
    public static func lastSide(_ sessions: [BreastSession]) -> BreastSide? {
        let latest = sessions.max { lhs, rhs in
            if lhs.end != rhs.end {
                return lhs.end < rhs.end
            }
            return lhs.start < rhs.start
        }
        return latest?.side
    }

    /// Sıradaki emzirme için önerilen göğüs yönünü döndürür.
    /// Son kullanılan göğsün tersidir; geçmiş oturum yoksa varsayılan olarak `.left` döner.
    public static func suggestedNextSide(_ sessions: [BreastSession]) -> BreastSide {
        guard let last = lastSide(sessions) else {
            return .left
        }
        return last.opposite
    }

    /// Verilen başlangıç tarihinden (`since`) itibaren sol ve sağ göğüste geçirilen toplam dakikaları hesaplar.
    /// `since` tarihinden önce başlayan oturumların yalnız `since` sonrasına düşen kısmı hesaba katılır.
    public static func balance(
        _ sessions: [BreastSession],
        since: Date
    ) -> (leftMinutes: Int, rightMinutes: Int) {
        var leftSeconds: TimeInterval = 0
        var rightSeconds: TimeInterval = 0

        for session in sessions {
            let effectiveStart = max(session.start, since)
            let duration = session.end.timeIntervalSince(effectiveStart)
            guard duration > 0 else { continue }

            switch session.side {
            case .left:
                leftSeconds += duration
            case .right:
                rightSeconds += duration
            }
        }

        let leftMinutes = Int((leftSeconds / 60.0).rounded())
        let rightMinutes = Int((rightSeconds / 60.0).rounded())
        return (leftMinutes: leftMinutes, rightMinutes: rightMinutes)
    }
}
