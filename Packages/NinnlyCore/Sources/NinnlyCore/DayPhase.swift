import Foundation

/// Uygulamanın gün içi görsel ve işlevsel fazı.
public enum DayPhase: String, Sendable, CaseIterable {
    case day
    case night
}

/// Gece ve gündüz fazı geçiş saatlerini belirleyen kural.
public struct DayPhaseRule: Sendable, Equatable {
    /// Bir gündeki toplam dakika sayısı (24 * 60).
    private static let minutesPerDay = 1440

    /// Gece fazının başladığı dakika (gece yarısından itibaren, 0..<1440 aralığında).
    public let nightStartMinute: Int

    /// Gece fazının bittiği dakika (gece yarısından itibaren, 0..<1440 aralığında).
    public let nightEndMinute: Int

    /// Varsayılan kural: 20:00 başlangıç, 06:30 bitiş.
    public static let standard = DayPhaseRule()

    /// Gece başlangıç ve bitiş dakikalarıyla yeni bir kural oluşturur.
    /// Girdi değerleri 0..<1440 aralığına normalize edilir.
    public init(nightStartMinute: Int = 20 * 60, nightEndMinute: Int = 6 * 60 + 30) {
        self.nightStartMinute = Self.normalizeMinute(nightStartMinute)
        self.nightEndMinute = Self.normalizeMinute(nightEndMinute)
    }

    /// Verilen tarihte hangi fazda olunduğunu hesaplar.
    /// Gece penceresi [nightStartMinute, nightEndMinute) yarı açık aralığıdır.
    public func phase(at date: Date, calendar: Calendar) -> DayPhase {
        // Başlangıç ve bitiş aynıysa gece penceresi boş kabul edilir, her zaman gündüzdür.
        if nightStartMinute == nightEndMinute {
            return .day
        }

        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let currentMinute = Self.normalizeMinute(hour * 60 + minute)

        if nightStartMinute < nightEndMinute {
            // Gece yarısını aşmayan pencere (ör. 01:00 - 05:00)
            let isNight = currentMinute >= nightStartMinute && currentMinute < nightEndMinute
            return isNight ? .night : .day
        } else {
            // Gece yarısını aşan pencere (ör. 20:00 - 06:30)
            let isNight = currentMinute >= nightStartMinute || currentMinute < nightEndMinute
            return isNight ? .night : .day
        }
    }

    /// Verilen tarihten sonra fazın değişeceği ilk anı döndürür.
    public func nextTransition(after date: Date, calendar: Calendar) -> Date {
        // Başlangıç ve bitiş eşitse faz hiç değişmez; güvenli varsayılan olarak ertesi gün başlangıcı döner.
        if nightStartMinute == nightEndMinute {
            let startOfToday = calendar.startOfDay(for: date)
            return calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? date.addingTimeInterval(86400)
        }

        let currentPhase = phase(at: date, calendar: calendar)
        // Şu an gündüzse sıradaki geçiş gece başlangıcıdır; geceyse gündüz başlangıcıdır (nightEndMinute).
        let targetMinute = (currentPhase == .day) ? nightStartMinute : nightEndMinute

        var matching = DateComponents()
        matching.hour = targetMinute / 60
        matching.minute = targetMinute % 60
        matching.second = 0

        if let nextDate = calendar.nextDate(
            after: date,
            matching: matching,
            matchingPolicy: .nextTime
        ) {
            return nextDate
        }

        // Takvim hesaplaması başarısız olursa güvenli geri dönüş olarak 1 saat sonrası.
        return date.addingTimeInterval(3600)
    }

    /// Dakika değerini 0..<1440 aralığına normalize eder.
    private static func normalizeMinute(_ value: Int) -> Int {
        let remainder = value % minutesPerDay
        return remainder >= 0 ? remainder : remainder + minutesPerDay
    }
}
