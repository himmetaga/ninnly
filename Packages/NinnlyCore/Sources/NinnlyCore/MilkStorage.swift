import Foundation

/// Anne sütünün saklandığı ortam türü.
/// Kaynak: CDC "Breast Milk Storage and Preparation"
/// (`https://www.cdc.gov/breastfeeding/breast-milk-preparation-and-storage/handling-breastmilk.html`,
/// Doğrulama Raporu A1 §4).
public enum MilkStorageLocation: String, Sendable, CaseIterable {
    case roomTemperature
    case refrigerator
    case freezer
    case thawedInRefrigerator
    /// Oda sıcaklığında (≤25 °C) çözdürülmüş süt.
    /// CDC 1–2 saat aralığı verir; güvenlik için tutucu alt sınır olan 1 saat uygulanır.
    case thawedAtRoomTemperature
    /// Bebek beslenmeye başladıktan sonra şişede kalan süt (beslenme bittikten sonra en fazla 2 saat içinde kullanılmalıdır).
    case leftoverAfterFeeding
}

/// Saklanan tek bir anne sütü poşeti veya şişesi kaydı.
public struct MilkStashItem: Sendable, Equatable, Identifiable {
    public let id: UUID
    public let volumeMl: Int
    public let location: MilkStorageLocation
    public let storedAt: Date

    public init(
        id: UUID = UUID(),
        volumeMl: Int,
        location: MilkStorageLocation,
        storedAt: Date
    ) {
        self.id = id
        self.volumeMl = volumeMl
        self.location = location
        self.storedAt = storedAt
    }
}

/// Saklanan sütün tazelik durumu.
public enum MilkFreshness: Sendable, Equatable {
    case fresh
    case useSoon
    case expired
}

/// Anne sütü saklama sürelerini ("4'ler kuralı") ve stok önceliğini hesaplayan kural.
public struct MilkStorageRule: Sendable, Equatable {
    // MARK: - Klinik Sabitler (Kaynak: CDC "Breast Milk Storage and Preparation", Doğrulama Raporu A1 §4)
    // Resmi URL: https://www.cdc.gov/breastfeeding/breast-milk-preparation-and-storage/handling-breastmilk.html

    /// Oda sıcaklığında (≤25 °C) azami güvenli saklama süresi (saat).
    /// Kaynak: CDC "Breast Milk Storage and Preparation".
    public static let roomTemperatureMaxHours = 4

    /// Buzdolabında (≤4 °C) taze sağılmış süt için azami güvenli saklama süresi (gün).
    /// Kaynak: CDC "Breast Milk Storage and Preparation".
    public static let refrigeratorMaxDays = 4

    /// Derin dondurucuda (≤-18 °C) en iyi kalite için önerilen saklama süresi (ay);
    /// 12 aya kadar saklama da kabul edilebilir.
    /// Kaynak: CDC "Breast Milk Storage and Preparation".
    public static let freezerBestQualityMaxMonths = 6

    /// Derin dondurucuda (≤-18 °C) kabul edilebilir azami saklama süresi (ay).
    /// Kaynak: CDC "Breast Milk Storage and Preparation" ("Up to 12 months is acceptable").
    public static let freezerAcceptableMaxMonths = 12

    /// Dondurucudan buzdolabına indirilerek çözdürülmüş süt için azami saklama süresi (saat).
    /// Kaynak: CDC "Breast Milk Storage and Preparation".
    public static let thawedInRefrigeratorMaxHours = 24

    /// Oda sıcaklığında (≤25 °C) çözdürülmüş süt için azami saklama süresi (saat).
    /// CDC 1–2 saat aralığı verir; tutucu alt sınır (1 saat) kullanılır.
    /// Kaynak: CDC "Breast Milk Storage and Preparation".
    public static let thawedAtRoomTemperatureMaxHours = 1

    /// Beslenme başladıktan sonra kalan süt için azami kullanım süresi (saat).
    /// Kaynak: CDC "Breast Milk Storage and Preparation" ("Use within 2 hours after the baby is finished feeding").
    public static let leftoverAfterFeedingMaxHours = 2

    /// Kalan süre toplam sürenin bu oranına (%20) eşit veya altına düştüğünde `.useSoon` döner.
    public static let useSoonRemainingRatio = 0.20

    /// Varsayılan kural örneği.
    public static let standard = MilkStorageRule()

    public init() {}

    // MARK: - Tür Yöntemleri

    /// Verilen süt kaydının son kullanma tarihini takvim matematiğiyle hesaplar.
    /// Derin dondurucu (`.freezer`) için en iyi kalite süresini (`freezerBestQualityMaxMonths` = 6 ay) esas alır.
    public static func expiry(for item: MilkStashItem, calendar: Calendar) -> Date {
        switch item.location {
        case .roomTemperature:
            return calendar.date(
                byAdding: .hour,
                value: roomTemperatureMaxHours,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(roomTemperatureMaxHours * 3600))

        case .refrigerator:
            return calendar.date(
                byAdding: .day,
                value: refrigeratorMaxDays,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(refrigeratorMaxDays * 86400))

        case .freezer:
            return calendar.date(
                byAdding: .month,
                value: freezerBestQualityMaxMonths,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(freezerBestQualityMaxMonths * 30 * 86400))

        case .thawedInRefrigerator:
            return calendar.date(
                byAdding: .hour,
                value: thawedInRefrigeratorMaxHours,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(thawedInRefrigeratorMaxHours * 3600))

        case .thawedAtRoomTemperature:
            return calendar.date(
                byAdding: .hour,
                value: thawedAtRoomTemperatureMaxHours,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(thawedAtRoomTemperatureMaxHours * 3600))

        case .leftoverAfterFeeding:
            return calendar.date(
                byAdding: .hour,
                value: leftoverAfterFeedingMaxHours,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(leftoverAfterFeedingMaxHours * 3600))
        }
    }

    /// Verilen süt kaydının kabul edilebilir azami son kullanma tarihini hesaplar.
    /// Derin dondurucu (`.freezer`) için 12 ay (`freezerAcceptableMaxMonths`), diğer tüm konumlar için `expiry(for:calendar:)` ile aynıdır.
    public static func acceptableExpiry(for item: MilkStashItem, calendar: Calendar) -> Date {
        switch item.location {
        case .freezer:
            return calendar.date(
                byAdding: .month,
                value: freezerAcceptableMaxMonths,
                to: item.storedAt
            ) ?? item.storedAt.addingTimeInterval(TimeInterval(freezerAcceptableMaxMonths * 30 * 86400))
        default:
            return expiry(for: item, calendar: calendar)
        }
    }

    /// Verilen tarihte süt kaydının tazelik durumunu belirler.
    /// Son kullanma anında veya sonrasında `.expired`, kalan süre toplam sürenin %20'si veya
    /// altındaysa `.useSoon`, aksi halde `.fresh` döner.
    public static func freshness(
        of item: MilkStashItem,
        at date: Date,
        calendar: Calendar
    ) -> MilkFreshness {
        let expiryDate = expiry(for: item, calendar: calendar)
        let remaining = expiryDate.timeIntervalSince(date)
        if remaining <= 0 {
            return .expired
        }

        let totalDuration = expiryDate.timeIntervalSince(item.storedAt)
        if totalDuration > 0 && remaining <= totalDuration * useSoonRemainingRatio {
            return .useSoon
        }

        return .fresh
    }

    /// Süresi dolmamış kayıtlar arasından son kullanma tarihi en yakın olanı döndürür.
    /// Son kullanma tarihi eşitse daha erken saklanan (`storedAt`) kayıt seçilir.
    public static func useFirst(
        _ items: [MilkStashItem],
        at date: Date,
        calendar: Calendar
    ) -> MilkStashItem? {
        let usable = items.filter { freshness(of: $0, at: date, calendar: calendar) != .expired }
        return usable.min { lhs, rhs in
            let lhsExpiry = expiry(for: lhs, calendar: calendar)
            let rhsExpiry = expiry(for: rhs, calendar: calendar)
            if lhsExpiry != rhsExpiry {
                return lhsExpiry < rhsExpiry
            }
            return lhs.storedAt < rhs.storedAt
        }
    }

    /// Süresi dolmamış tüm süt kayıtlarının toplam hacmini (ml) döndürür.
    public static func totalUsableMl(
        _ items: [MilkStashItem],
        at date: Date,
        calendar: Calendar
    ) -> Int {
        items
            .filter { freshness(of: $0, at: date, calendar: calendar) != .expired }
            .reduce(0) { $0 + max(0, $1.volumeMl) }
    }

    /// Süt kaydını yeni bir saklama ortamına taşır ve süreyi taşıma anından yeniden başlatır.
    /// Yasaklı taşımalar için `nil` döndürür:
    /// - Çözdürülmüş süt (`.thawedInRefrigerator` veya `.thawedAtRoomTemperature`) asla tekrar dondurucuya (`.freezer`) konulamaz.
    /// - Beslenme sonrası kalan süt (`.leftoverAfterFeeding`) hiçbir ortama taşınamaz.
    /// Ortam dönüşümleri:
    /// - `.freezer` → `.refrigerator` = `.thawedInRefrigerator`
    /// - `.freezer` → `.roomTemperature` = `.thawedAtRoomTemperature`
    /// - `.thawedInRefrigerator` → `.roomTemperature` = `.thawedAtRoomTemperature`
    /// - Diğer izin verilen taşımalar hedef konumu korur.
    public static func moved(
        _ item: MilkStashItem,
        to newLocation: MilkStorageLocation,
        at date: Date
    ) -> MilkStashItem? {
        if item.location == .leftoverAfterFeeding {
            return nil
        }

        if (item.location == .thawedInRefrigerator || item.location == .thawedAtRoomTemperature)
            && newLocation == .freezer
        {
            return nil
        }

        let resolvedLocation: MilkStorageLocation
        switch (item.location, newLocation) {
        case (.freezer, .refrigerator):
            resolvedLocation = .thawedInRefrigerator
        case (.freezer, .roomTemperature), (.thawedInRefrigerator, .roomTemperature):
            resolvedLocation = .thawedAtRoomTemperature
        default:
            resolvedLocation = newLocation
        }

        return MilkStashItem(
            id: item.id,
            volumeMl: item.volumeMl,
            location: resolvedLocation,
            storedAt: date
        )
    }

    /// Bebeğin verilen sütle beslenmeye başladığını işaretler; aynı kimlik ve hacimle
    /// konumu `.leftoverAfterFeeding` olarak günceller ve süreyi verilen tarihten başlatır.
    public static func feedingStarted(_ item: MilkStashItem, at date: Date) -> MilkStashItem {
        MilkStashItem(
            id: item.id,
            volumeMl: item.volumeMl,
            location: .leftoverAfterFeeding,
            storedAt: date
        )
    }

    // MARK: - Örnek Yöntemleri

    /// Verilen süt kaydının son kullanma tarihini takvim matematiğiyle hesaplar.
    public func expiry(for item: MilkStashItem, calendar: Calendar) -> Date {
        Self.expiry(for: item, calendar: calendar)
    }

    /// Verilen süt kaydının kabul edilebilir azami son kullanma tarihini hesaplar.
    public func acceptableExpiry(for item: MilkStashItem, calendar: Calendar) -> Date {
        Self.acceptableExpiry(for: item, calendar: calendar)
    }

    /// Verilen tarihte süt kaydının tazelik durumunu belirler.
    public func freshness(
        of item: MilkStashItem,
        at date: Date,
        calendar: Calendar
    ) -> MilkFreshness {
        Self.freshness(of: item, at: date, calendar: calendar)
    }

    /// Süresi dolmamış kayıtlar arasından ilk kullanılması gerekeni döndürür.
    public func useFirst(
        _ items: [MilkStashItem],
        at date: Date,
        calendar: Calendar
    ) -> MilkStashItem? {
        Self.useFirst(items, at: date, calendar: calendar)
    }

    /// Süresi dolmamış tüm süt kayıtlarının toplam hacmini (ml) döndürür.
    public func totalUsableMl(
        _ items: [MilkStashItem],
        at date: Date,
        calendar: Calendar
    ) -> Int {
        Self.totalUsableMl(items, at: date, calendar: calendar)
    }

    /// Süt kaydını yeni bir saklama ortamına taşır ve süreyi taşıma anından yeniden başlatır.
    public func moved(
        _ item: MilkStashItem,
        to newLocation: MilkStorageLocation,
        at date: Date
    ) -> MilkStashItem? {
        Self.moved(item, to: newLocation, at: date)
    }

    /// Bebeğin verilen sütle beslenmeye başladığını işaretler.
    public func feedingStarted(_ item: MilkStashItem, at date: Date) -> MilkStashItem {
        Self.feedingStarted(item, at: date)
    }
}
