import Foundation

/// Yaşa göre önerilen uyanıklık süresi bandı (dakika cinsinden alt/üst sınır ve tipik gündüz uykusu sayısı).
public struct WakeWindowBand: Sendable, Equatable {
    // MARK: - Klinik Sabitler (Kaynak: Rapor §4 "Klinik Algoritma 1")
    // Kaynak tablodaki 4-5 ay boşluğu ve 7. ay çakışması kesintisiz gün bantlarıyla giderilmiştir:
    // - 0..<28 gün (0-4 hafta): 30-60 dk, 5 uyku
    // - 28..<84 gün (4-12 hafta): 60-90 dk, 4 uyku
    // - 84..<150 gün (3-5 ay): 75-120 dk, 4 uyku
    // - 150..<210 gün (5-7 ay): 120-180 dk, 3 uyku
    // - 210..<330 gün (7-11 ay): 150-210 dk, 2 uyku
    // - 330..<420 gün (11-14 ay): 180-240 dk, 2 uyku
    // - 420+ gün (14-24+ ay): 240-360 dk, 1 uyku

    /// 0-4 hafta üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let weeks4DayLimit = 28
    /// 4-12 hafta üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let weeks12DayLimit = 84
    /// 3-5 ay üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months5DayLimit = 150
    /// 5-7 ay üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months7DayLimit = 210
    /// 7-11 ay üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months11DayLimit = 330
    /// 11-14 ay üst gün sınırı (hariç). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months14DayLimit = 420

    /// 0-4 hafta bandı (30-60 dk, 5 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let weeks0To4 = WakeWindowBand(minMinutes: 30, maxMinutes: 60, typicalNaps: 5)
    /// 4-12 hafta bandı (60-90 dk, 4 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let weeks4To12 = WakeWindowBand(minMinutes: 60, maxMinutes: 90, typicalNaps: 4)
    /// 3-5 ay bandı (75-120 dk, 4 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months3To5 = WakeWindowBand(minMinutes: 75, maxMinutes: 120, typicalNaps: 4)
    /// 5-7 ay bandı (120-180 dk, 3 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months5To7 = WakeWindowBand(minMinutes: 120, maxMinutes: 180, typicalNaps: 3)
    /// 7-11 ay bandı (150-210 dk, 2 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months7To11 = WakeWindowBand(minMinutes: 150, maxMinutes: 210, typicalNaps: 2)
    /// 11-14 ay bandı (180-240 dk, 2 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1" ve Doğrulama Raporu A1 §5.
    public static let months11To14 = WakeWindowBand(minMinutes: 180, maxMinutes: 240, typicalNaps: 2)
    /// 11-14 ayda tek gündüz uykusuna geçen bebekler için bant (270-330 dk, 1 uyku).
    /// Kaynak: Doğrulama Raporu A1 §5 (`docs/arastirma/A1_kaynak_dogrulama.md` §5 tablosu — Cleveland Clinic, Huckleberry, Taking Cara Babies).
    public static let months11To14OneNap = WakeWindowBand(minMinutes: 270, maxMinutes: 330, typicalNaps: 1)
    /// 14-24+ ay bandı (240-360 dk, 1 uyku). Kaynak: Rapor §4 "Klinik Algoritma 1".
    public static let months14Plus = WakeWindowBand(minMinutes: 240, maxMinutes: 360, typicalNaps: 1)

    public let minMinutes: Int
    public let maxMinutes: Int
    public let typicalNaps: Int

    public init(minMinutes: Int, maxMinutes: Int, typicalNaps: Int) {
        self.minMinutes = minMinutes
        self.maxMinutes = maxMinutes
        self.typicalNaps = typicalNaps
    }

    /// Bebeğin gün cinsinden yaşına karşılık gelen uyanıklık penceresi bandını döndürür.
    /// Negatif gün değerleri 0 kabul edilir; 24 aydan büyük yaşlar 14-24 ay bandını kullanır.
    public static func band(forAgeInDays ageInDays: Int) -> WakeWindowBand {
        band(forAgeInDays: ageInDays, napsPerDay: nil)
    }

    /// Bebeğin gün cinsinden yaşına ve opsiyonel günlük uyku sayısına karşılık gelen uyanıklık penceresi bandını döndürür.
    /// Yaş 11–14 ay aralığında (`330..<420` gün) ve `napsPerDay == 1` olduğunda `months11To14OneNap` döndürülür;
    /// diğer tüm durumlarda yaşa göre standart bant kullanılır.
    public static func band(forAgeInDays ageInDays: Int, napsPerDay: Int?) -> WakeWindowBand {
        let clampedAge = max(0, ageInDays)
        switch clampedAge {
        case ..<weeks4DayLimit:
            return weeks0To4
        case weeks4DayLimit..<weeks12DayLimit:
            return weeks4To12
        case weeks12DayLimit..<months5DayLimit:
            return months3To5
        case months5DayLimit..<months7DayLimit:
            return months5To7
        case months7DayLimit..<months11DayLimit:
            return months7To11
        case months11DayLimit..<months14DayLimit:
            if napsPerDay == 1 {
                return months11To14OneNap
            }
            return months11To14
        default:
            return months14Plus
        }
    }
}

/// Yaşa, gün içi uyku sırasına ve son 7 günlük gözlemlere göre sıradaki Uyku Penceresi aralığını tahmin eder.
///
/// - Important: Uyanıklık pencereleri (wake windows) resmi bir tıbbi standart veya klinik kılavuz değil,
///   davranışsal rehber aralıklarıdır. Kullanıcı arayüzü (UI) bu tahminlerin tıbbi standart olmadığını ve
///   bebeğin bireysel yorgunluk/uyku sinyalleriyle birlikte değerlendirilmesi gerektiğini açıkça göstermelidir
///   (Kaynak: Doğrulama Raporu A1 §5 / §8).
public struct WakeWindowPredictor: Sendable, Equatable {
    // MARK: - Algoritma Sabitleri (Kaynak: Rapor §4 "Klinik Algoritma 1")

    /// Gözlenen uyanıklık sürelerini harmanlamak için gereken asgari örnek sayısı.
    public static let minimumRecentSamplesForBlend = 3
    /// Yaş tablosu taban değerinin harmanlama ağırlığı.
    public static let baseWeight = 0.60
    /// Gözlenen son uyanıklık süreleri ortalamasının harmanlama ağırlığı.
    public static let recentMeanWeight = 0.40
    /// Günün ilk uykusu (`napIndexToday == 0`) için pozisyon çarpanı.
    public static let firstNapFactor = 0.85
    /// Günün son uykusu (`napIndexToday == typicalNaps`) için pozisyon çarpanı.
    public static let lastNapFactor = 1.15
    /// Tahmin edilen merkez sürenin etrafındaki pencere yarı genişlik oranı (±%15).
    public static let intervalHalfWidthRatio = 0.15

    /// Varsayılan tahminleyici örneği.
    public static let standard = WakeWindowPredictor()

    public init() {}

    /// Bebeğin gün cinsinden yaşına karşılık gelen uyanıklık penceresi bandını döndürür.
    public static func band(forAgeInDays ageInDays: Int) -> WakeWindowBand {
        WakeWindowBand.band(forAgeInDays: ageInDays, napsPerDay: nil)
    }

    /// Bebeğin gün cinsinden yaşına ve opsiyonel günlük uyku sayısına karşılık gelen uyanıklık penceresi bandını döndürür.
    public static func band(forAgeInDays ageInDays: Int, napsPerDay: Int?) -> WakeWindowBand {
        WakeWindowBand.band(forAgeInDays: ageInDays, napsPerDay: napsPerDay)
    }

    /// Sıradaki Uyku Penceresi zaman aralığını hesaplar.
    public static func predictNextSleep(
        lastWake: Date,
        birthDate: Date,
        napIndexToday: Int,
        recentWakeMinutes: [Int],
        calendar: Calendar,
        napsPerDay: Int? = nil
    ) -> DateInterval {
        let birthStart = calendar.startOfDay(for: birthDate)
        let wakeStart = calendar.startOfDay(for: lastWake)
        let ageInDays = max(0, calendar.dateComponents([.day], from: birthStart, to: wakeStart).day ?? 0)
        let band = WakeWindowBand.band(forAgeInDays: ageInDays, napsPerDay: napsPerDay)

        // a) Taban değer bandın orta noktasıdır; en az 3 geçmiş gözlem varsa sınırlandırılmış ortalamayla harmanlanır.
        let baseMinutes = Double(band.minMinutes + band.maxMinutes) / 2.0
        let blendedMinutes: Double
        if recentWakeMinutes.count >= minimumRecentSamplesForBlend {
            let clampedSum = recentWakeMinutes.reduce(0.0) { partial, sample in
                let clamped = min(max(sample, band.minMinutes), band.maxMinutes)
                return partial + Double(clamped)
            }
            let recentMean = clampedSum / Double(recentWakeMinutes.count)
            blendedMinutes = baseWeight * baseMinutes + recentMeanWeight * recentMean
        } else {
            blendedMinutes = baseMinutes
        }

        // b) Gün içi uyku sırasına göre doğrusal pozisyon çarpanı (0 -> 0.85, typicalNaps -> 1.15).
        let positionFactor: Double
        if band.typicalNaps > 0 {
            let clampedIndex = min(max(napIndexToday, 0), band.typicalNaps)
            let progress = Double(clampedIndex) / Double(band.typicalNaps)
            positionFactor = firstNapFactor + (lastNapFactor - firstNapFactor) * progress
        } else {
            positionFactor = 1.0
        }

        let adjustedMinutes = blendedMinutes * positionFactor

        // c) Pencere aralığı: merkez ±%15, [min, max * 1.15] aralığına sınırlandırılmış.
        let lowerLimitMinutes = Double(band.minMinutes)
        let upperLimitMinutes = Double(band.maxMinutes) * lastNapFactor

        let rawStartMinutes = adjustedMinutes * (1.0 - intervalHalfWidthRatio)
        let rawEndMinutes = adjustedMinutes * (1.0 + intervalHalfWidthRatio)

        let startMinutes = min(max(rawStartMinutes, lowerLimitMinutes), upperLimitMinutes)
        let endMinutes = min(max(rawEndMinutes, startMinutes), upperLimitMinutes)

        let startDate = lastWake.addingTimeInterval(startMinutes * 60.0)
        let endDate = lastWake.addingTimeInterval(endMinutes * 60.0)
        return DateInterval(start: startDate, end: endDate)
    }

    /// Sıradaki Uyku Penceresi zaman aralığını hesaplar.
    public func predictNextSleep(
        lastWake: Date,
        birthDate: Date,
        napIndexToday: Int,
        recentWakeMinutes: [Int],
        calendar: Calendar,
        napsPerDay: Int? = nil
    ) -> DateInterval {
        Self.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: napIndexToday,
            recentWakeMinutes: recentWakeMinutes,
            calendar: calendar,
            napsPerDay: napsPerDay
        )
    }
}
