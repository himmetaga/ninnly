import Foundation
import XCTest
@testable import NinnlyCore

/// Anne sütü saklama ("4'ler kuralı") ve stok yönetimi birim testleri.
final class MilkStorageTests: XCTestCase {
    /// Sabit Europe/Istanbul saat dilimli Miladi takvim oluşturur.
    private func makeIstanbulCalendar() throws -> Calendar {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "Europe/Istanbul"))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }

    /// Yardımcı tarih oluşturucu.
    private func makeDate(
        year: Int = 2026,
        month: Int = 11,
        day: Int = 16,
        hour: Int = 10,
        minute: Int = 0,
        second: Int = 0,
        calendar: Calendar
    ) throws -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        return try XCTUnwrap(calendar.date(from: components))
    }

    func testExpiryByLocationUsesCalendarMath() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let storedAt = try makeDate(year: 2026, month: 1, day: 15, hour: 8, minute: 30, calendar: calendar)

        // Oda sıcaklığı: +4 saat
        let roomItem = MilkStashItem(volumeMl: 90, location: .roomTemperature, storedAt: storedAt)
        let expectedRoomExpiry = try makeDate(year: 2026, month: 1, day: 15, hour: 12, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: roomItem, calendar: calendar), expectedRoomExpiry)

        // Buzdolabı: +4 gün
        let fridgeItem = MilkStashItem(volumeMl: 120, location: .refrigerator, storedAt: storedAt)
        let expectedFridgeExpiry = try makeDate(year: 2026, month: 1, day: 19, hour: 8, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: fridgeItem, calendar: calendar), expectedFridgeExpiry)

        // Derin dondurucu (en iyi kalite): +6 takvim ayı
        let freezerItem = MilkStashItem(volumeMl: 150, location: .freezer, storedAt: storedAt)
        let expectedFreezerExpiry = try makeDate(year: 2026, month: 7, day: 15, hour: 8, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: freezerItem, calendar: calendar), expectedFreezerExpiry)

        // Buzdolabında çözdürülmüş: +24 saat
        let thawedItem = MilkStashItem(volumeMl: 100, location: .thawedInRefrigerator, storedAt: storedAt)
        let expectedThawedExpiry = try makeDate(year: 2026, month: 1, day: 16, hour: 8, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: thawedItem, calendar: calendar), expectedThawedExpiry)

        // Oda sıcaklığında çözdürülmüş: +1 saat (CDC 1–2 saat aralığının tutucu alt sınırı)
        let thawedRoomItem = MilkStashItem(volumeMl: 80, location: .thawedAtRoomTemperature, storedAt: storedAt)
        let expectedThawedRoomExpiry = try makeDate(year: 2026, month: 1, day: 15, hour: 9, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: thawedRoomItem, calendar: calendar), expectedThawedRoomExpiry)

        // Beslenme sonrası kalan süt: +2 saat
        let leftoverItem = MilkStashItem(volumeMl: 60, location: .leftoverAfterFeeding, storedAt: storedAt)
        let expectedLeftoverExpiry = try makeDate(year: 2026, month: 1, day: 15, hour: 10, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: leftoverItem, calendar: calendar), expectedLeftoverExpiry)
    }

    func testNewLocationsFreshnessAndExpiryBoundaries() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let storedAt = try makeDate(hour: 10, minute: 0, second: 0, calendar: calendar)

        // Oda sıcaklığında çözdürülmüş süt: toplam 1 saat = 60 dk; %20 eşik = 12 dk kalan (10:48:00).
        let thawedRoom = MilkStashItem(volumeMl: 80, location: .thawedAtRoomTemperature, storedAt: storedAt)
        XCTAssertEqual(
            rule.freshness(of: thawedRoom, at: try makeDate(hour: 10, minute: 47, second: 59, calendar: calendar), calendar: calendar),
            .fresh
        )
        XCTAssertEqual(
            rule.freshness(of: thawedRoom, at: try makeDate(hour: 10, minute: 48, second: 0, calendar: calendar), calendar: calendar),
            .useSoon
        )
        XCTAssertEqual(
            rule.freshness(of: thawedRoom, at: try makeDate(hour: 10, minute: 59, second: 59, calendar: calendar), calendar: calendar),
            .useSoon
        )
        XCTAssertEqual(
            rule.freshness(of: thawedRoom, at: try makeDate(hour: 11, minute: 0, second: 0, calendar: calendar), calendar: calendar),
            .expired
        )

        // Beslenme sonrası kalan süt: toplam 2 saat = 120 dk; %20 eşik = 24 dk kalan (11:36:00).
        let leftover = MilkStashItem(volumeMl: 50, location: .leftoverAfterFeeding, storedAt: storedAt)
        XCTAssertEqual(
            rule.freshness(of: leftover, at: try makeDate(hour: 11, minute: 35, second: 59, calendar: calendar), calendar: calendar),
            .fresh
        )
        XCTAssertEqual(
            rule.freshness(of: leftover, at: try makeDate(hour: 11, minute: 36, second: 0, calendar: calendar), calendar: calendar),
            .useSoon
        )
        XCTAssertEqual(
            rule.freshness(of: leftover, at: try makeDate(hour: 11, minute: 59, second: 59, calendar: calendar), calendar: calendar),
            .useSoon
        )
        XCTAssertEqual(
            rule.freshness(of: leftover, at: try makeDate(hour: 12, minute: 0, second: 0, calendar: calendar), calendar: calendar),
            .expired
        )
    }

    func testAcceptableExpiryVersusBestQualityFreezerExpiry() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let storedAt = try makeDate(year: 2026, month: 1, day: 15, hour: 8, minute: 30, calendar: calendar)

        // Derin dondurucu: en iyi kalite 6 ay, kabul edilebilir azami süre 12 ay.
        let freezerItem = MilkStashItem(volumeMl: 150, location: .freezer, storedAt: storedAt)
        let expectedBestExpiry = try makeDate(year: 2026, month: 7, day: 15, hour: 8, minute: 30, calendar: calendar)
        let expectedAcceptableExpiry = try makeDate(year: 2027, month: 1, day: 15, hour: 8, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: freezerItem, calendar: calendar), expectedBestExpiry)
        XCTAssertEqual(rule.acceptableExpiry(for: freezerItem, calendar: calendar), expectedAcceptableExpiry)
        XCTAssertEqual(MilkStorageRule.acceptableExpiry(for: freezerItem, calendar: calendar), expectedAcceptableExpiry)

        // Diğer tüm saklama konumlarında acceptableExpiry == expiry olmalıdır.
        for location in MilkStorageLocation.allCases where location != .freezer {
            let item = MilkStashItem(volumeMl: 100, location: location, storedAt: storedAt)
            XCTAssertEqual(
                rule.acceptableExpiry(for: item, calendar: calendar),
                rule.expiry(for: item, calendar: calendar),
                "\(location) için acceptableExpiry ile expiry eşit olmalıdır"
            )
        }
    }

    func testFreshnessTwentyPercentAndExpiryBoundaries() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let storedAt = try makeDate(hour: 10, minute: 0, second: 0, calendar: calendar)
        let item = MilkStashItem(volumeMl: 100, location: .roomTemperature, storedAt: storedAt)

        // Toplam süre 4 saat = 240 dakika; %20 kalan süre = 48 dakika (yani 13:12).
        // 13:11:59 -> kalan süre 48 dk 1 sn (> %20) -> .fresh
        let justBeforeThreshold = try makeDate(hour: 13, minute: 11, second: 59, calendar: calendar)
        XCTAssertEqual(rule.freshness(of: item, at: justBeforeThreshold, calendar: calendar), .fresh)

        // 13:12:00 -> kalan süre tam 48 dk (== %20) -> .useSoon
        let exactThreshold = try makeDate(hour: 13, minute: 12, second: 0, calendar: calendar)
        XCTAssertEqual(rule.freshness(of: item, at: exactThreshold, calendar: calendar), .useSoon)

        // 13:59:59 -> kalan süre 1 sn -> .useSoon
        let justBeforeExpiry = try makeDate(hour: 13, minute: 59, second: 59, calendar: calendar)
        XCTAssertEqual(rule.freshness(of: item, at: justBeforeExpiry, calendar: calendar), .useSoon)

        // 14:00:00 -> tam son kullanma anı -> .expired
        let exactExpiry = try makeDate(hour: 14, minute: 0, second: 0, calendar: calendar)
        XCTAssertEqual(rule.freshness(of: item, at: exactExpiry, calendar: calendar), .expired)

        // 14:30:00 -> son kullanma sonrası -> .expired
        let afterExpiry = try makeDate(hour: 14, minute: 30, second: 0, calendar: calendar)
        XCTAssertEqual(rule.freshness(of: item, at: afterExpiry, calendar: calendar), .expired)
    }

    func testUseFirstPicksEarliestExpiryAndBreaksTiesByStoredAt() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let now = try makeDate(day: 16, hour: 12, minute: 0, calendar: calendar)

        // Süresi dolmuş kayıt (07:00'da odaya konmuş, 11:00'da dolmuş) -> elenmeli
        let expiredRoom = MilkStashItem(
            volumeMl: 80,
            location: .roomTemperature,
            storedAt: try makeDate(day: 16, hour: 7, minute: 0, calendar: calendar)
        )

        // Geçerli kayıt 1: buzdolabında, 16 Kasım 10:00'da konmuş -> 20 Kasım 10:00'da dolar
        let fridgeLater = MilkStashItem(
            volumeMl: 120,
            location: .refrigerator,
            storedAt: try makeDate(day: 16, hour: 10, minute: 0, calendar: calendar)
        )

        // Geçerli kayıt 2: oda sıcaklığında, 16 Kasım 10:00'da konmuş -> 16 Kasım 14:00'da dolar
        let roomValid = MilkStashItem(
            volumeMl: 90,
            location: .roomTemperature,
            storedAt: try makeDate(day: 16, hour: 10, minute: 0, calendar: calendar)
        )

        let picked = rule.useFirst([expiredRoom, fridgeLater, roomValid], at: now, calendar: calendar)
        XCTAssertEqual(picked, roomValid)

        // Eşit son kullanma tarihi durumu:
        // Kayıt A: 13 Kasım 14:00'da buzdolabına konmuş -> son kullanma 17 Kasım 14:00
        let earlierStored = MilkStashItem(
            volumeMl: 100,
            location: .refrigerator,
            storedAt: try makeDate(day: 13, hour: 14, minute: 0, calendar: calendar)
        )
        // Kayıt B: 16 Kasım 14:00'da çözdürülmeye konmuş -> son kullanma 17 Kasım 14:00
        let laterStoredSameExpiry = MilkStashItem(
            volumeMl: 110,
            location: .thawedInRefrigerator,
            storedAt: try makeDate(day: 16, hour: 14, minute: 0, calendar: calendar)
        )

        let tieCheckDate = try makeDate(day: 16, hour: 15, minute: 0, calendar: calendar)
        let tieBroken = rule.useFirst([laterStoredSameExpiry, earlierStored], at: tieCheckDate, calendar: calendar)
        XCTAssertEqual(tieBroken, earlierStored)
    }

    func testTotalUsableMlExcludesExpiredItems() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let now = try makeDate(day: 16, hour: 15, minute: 0, calendar: calendar)

        let expired = MilkStashItem(
            volumeMl: 100,
            location: .roomTemperature,
            storedAt: try makeDate(day: 16, hour: 10, minute: 0, calendar: calendar)
        )
        let useSoon = MilkStashItem(
            volumeMl: 90,
            location: .roomTemperature,
            storedAt: try makeDate(day: 16, hour: 11, minute: 30, calendar: calendar)
        )
        let fresh = MilkStashItem(
            volumeMl: 150,
            location: .refrigerator,
            storedAt: try makeDate(day: 16, hour: 12, minute: 0, calendar: calendar)
        )

        let total = rule.totalUsableMl([expired, useSoon, fresh], at: now, calendar: calendar)
        XCTAssertEqual(total, 240)
    }

    func testMovedStartsNewClockAndHandlesAllowedTransitionsAndForbiddenMoves() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let initialDate = try makeDate(day: 1, hour: 9, minute: 0, calendar: calendar)
        let moveDate = try makeDate(day: 16, hour: 18, minute: 0, calendar: calendar)

        let frozenItem = MilkStashItem(
            volumeMl: 140,
            location: .freezer,
            storedAt: initialDate
        )

        // Dondurucudan buzdolabına geçiş -> .thawedInRefrigerator ve yeni storedAt
        let thawedInFridge = try XCTUnwrap(rule.moved(frozenItem, to: .refrigerator, at: moveDate))
        XCTAssertEqual(thawedInFridge.id, frozenItem.id)
        XCTAssertEqual(thawedInFridge.volumeMl, frozenItem.volumeMl)
        XCTAssertEqual(thawedInFridge.location, .thawedInRefrigerator)
        XCTAssertEqual(thawedInFridge.storedAt, moveDate)

        // Dondurucudan oda sıcaklığına geçiş -> .thawedAtRoomTemperature
        let thawedAtRoomFromFreezer = try XCTUnwrap(rule.moved(frozenItem, to: .roomTemperature, at: moveDate))
        XCTAssertEqual(thawedAtRoomFromFreezer.id, frozenItem.id)
        XCTAssertEqual(thawedAtRoomFromFreezer.volumeMl, frozenItem.volumeMl)
        XCTAssertEqual(thawedAtRoomFromFreezer.location, .thawedAtRoomTemperature)
        XCTAssertEqual(thawedAtRoomFromFreezer.storedAt, moveDate)

        // Buzdolabında çözdürülmüş sütten oda sıcaklığına geçiş -> .thawedAtRoomTemperature
        let laterMoveDate = try makeDate(day: 16, hour: 19, minute: 0, calendar: calendar)
        let thawedAtRoomFromThawedFridge = try XCTUnwrap(
            rule.moved(thawedInFridge, to: .roomTemperature, at: laterMoveDate)
        )
        XCTAssertEqual(thawedAtRoomFromThawedFridge.id, frozenItem.id)
        XCTAssertEqual(thawedAtRoomFromThawedFridge.location, .thawedAtRoomTemperature)
        XCTAssertEqual(thawedAtRoomFromThawedFridge.storedAt, laterMoveDate)

        // Oda sıcaklığından buzdolabına geçiş -> .refrigerator
        let roomItem = MilkStashItem(volumeMl: 80, location: .roomTemperature, storedAt: initialDate)
        let chilled = try XCTUnwrap(rule.moved(roomItem, to: .refrigerator, at: moveDate))
        XCTAssertEqual(chilled.location, .refrigerator)
        XCTAssertEqual(chilled.storedAt, moveDate)

        // Yasaklı taşıma 1: Çözdürülmüş süt tekrar dondurulamaz (never refreeze -> nil)
        XCTAssertNil(rule.moved(thawedInFridge, to: .freezer, at: laterMoveDate))
        XCTAssertNil(rule.moved(thawedAtRoomFromFreezer, to: .freezer, at: laterMoveDate))
        XCTAssertNil(MilkStorageRule.moved(thawedInFridge, to: .freezer, at: laterMoveDate))

        // Yasaklı taşıma 2: Beslenme sonrası kalan süt (.leftoverAfterFeeding) hiçbir yere taşınamaz
        let leftoverItem = MilkStashItem(volumeMl: 60, location: .leftoverAfterFeeding, storedAt: initialDate)
        for destination in MilkStorageLocation.allCases {
            XCTAssertNil(
                rule.moved(leftoverItem, to: destination, at: moveDate),
                ".leftoverAfterFeeding konumundan \(destination) konumuna taşıma nil dönmelidir"
            )
        }
    }

    func testFeedingStartedTransitionsToLeftoverAndResetsClock() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = MilkStorageRule.standard
        let storedAt = try makeDate(day: 15, hour: 10, minute: 0, calendar: calendar)
        let feedStart = try makeDate(day: 16, hour: 14, minute: 15, calendar: calendar)

        let fridgeItem = MilkStashItem(volumeMl: 120, location: .refrigerator, storedAt: storedAt)
        let started = rule.feedingStarted(fridgeItem, at: feedStart)

        XCTAssertEqual(started.id, fridgeItem.id)
        XCTAssertEqual(started.volumeMl, fridgeItem.volumeMl)
        XCTAssertEqual(started.location, .leftoverAfterFeeding)
        XCTAssertEqual(started.storedAt, feedStart)
        XCTAssertEqual(MilkStorageRule.feedingStarted(fridgeItem, at: feedStart), started)

        // Beslenme başladıktan sonra 2 saatlik son kullanma süresi işler ve başka ortama taşınamaz.
        let expectedExpiry = try makeDate(day: 16, hour: 16, minute: 15, calendar: calendar)
        XCTAssertEqual(rule.expiry(for: started, calendar: calendar), expectedExpiry)
        XCTAssertNil(rule.moved(started, to: .refrigerator, at: feedStart))
    }
}
