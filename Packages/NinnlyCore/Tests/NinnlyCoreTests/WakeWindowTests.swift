import Foundation
import XCTest
@testable import NinnlyCore

/// Uyku Penceresi yaş bantları ve tahmin algoritması birim testleri.
final class WakeWindowTests: XCTestCase {
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
        hour: Int = 8,
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

    func testBandEdgesByAgeInDays() {
        // Negatif ve 0..<28 gün -> 30-60 dk (5 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: -5), WakeWindowBand(minMinutes: 30, maxMinutes: 60, typicalNaps: 5))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 0), WakeWindowBand(minMinutes: 30, maxMinutes: 60, typicalNaps: 5))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 27), WakeWindowBand(minMinutes: 30, maxMinutes: 60, typicalNaps: 5))

        // 28..<84 gün (4-12 hafta) -> 60-90 dk (4 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 28), WakeWindowBand(minMinutes: 60, maxMinutes: 90, typicalNaps: 4))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 83), WakeWindowBand(minMinutes: 60, maxMinutes: 90, typicalNaps: 4))

        // 84..<150 gün (3-5 ay) -> 75-120 dk (4 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 84), WakeWindowBand(minMinutes: 75, maxMinutes: 120, typicalNaps: 4))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 149), WakeWindowBand(minMinutes: 75, maxMinutes: 120, typicalNaps: 4))

        // 150..<210 gün (5-7 ay) -> 120-180 dk (3 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 150), WakeWindowBand(minMinutes: 120, maxMinutes: 180, typicalNaps: 3))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 209), WakeWindowBand(minMinutes: 120, maxMinutes: 180, typicalNaps: 3))

        // 210..<330 gün (7-11 ay) -> 150-210 dk (2 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 210), WakeWindowBand(minMinutes: 150, maxMinutes: 210, typicalNaps: 2))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 329), WakeWindowBand(minMinutes: 150, maxMinutes: 210, typicalNaps: 2))

        // 330..<420 gün (11-14 ay) -> 180-240 dk (2 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 330), WakeWindowBand(minMinutes: 180, maxMinutes: 240, typicalNaps: 2))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 419), WakeWindowBand(minMinutes: 180, maxMinutes: 240, typicalNaps: 2))

        // 420+ gün (14-24+ ay) -> 240-360 dk (1 uyku)
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 420), WakeWindowBand(minMinutes: 240, maxMinutes: 360, typicalNaps: 1))
        XCTAssertEqual(WakeWindowBand.band(forAgeInDays: 900), WakeWindowBand(minMinutes: 240, maxMinutes: 360, typicalNaps: 1))
    }

    func testMonths11To14BandWithNapsPerDayOneVersusTwoVersusNilAndOutsideRange() throws {
        // 11–14 ay (330..<420 gün): napsPerDay == 1 -> months11To14OneNap (270–330 dk, 1 uyku)
        XCTAssertEqual(
            WakeWindowBand.band(forAgeInDays: 330, napsPerDay: 1),
            WakeWindowBand.months11To14OneNap
        )
        XCTAssertEqual(
            WakeWindowBand.band(forAgeInDays: 360, napsPerDay: 1),
            WakeWindowBand(minMinutes: 270, maxMinutes: 330, typicalNaps: 1)
        )
        XCTAssertEqual(
            WakeWindowPredictor.band(forAgeInDays: 419, napsPerDay: 1),
            WakeWindowBand.months11To14OneNap
        )

        // 11–14 ay: napsPerDay == 2 veya nil -> months11To14 (180–240 dk, 2 uyku)
        XCTAssertEqual(
            WakeWindowBand.band(forAgeInDays: 360, napsPerDay: 2),
            WakeWindowBand.months11To14
        )
        XCTAssertEqual(
            WakeWindowBand.band(forAgeInDays: 360, napsPerDay: nil),
            WakeWindowBand.months11To14
        )
        XCTAssertEqual(
            WakeWindowPredictor.band(forAgeInDays: 360, napsPerDay: 2),
            WakeWindowBand(minMinutes: 180, maxMinutes: 240, typicalNaps: 2)
        )

        // 11–14 ay dışındaki yaşlarda napsPerDay == 1 verilse dahi months11To14OneNap kullanılmaz
        let outsideAges = [0, 27, 60, 120, 180, 250, 329, 420, 600]
        for age in outsideAges {
            let withOneNap = WakeWindowBand.band(forAgeInDays: age, napsPerDay: 1)
            let defaultBand = WakeWindowBand.band(forAgeInDays: age)
            XCTAssertEqual(withOneNap, defaultBand, "\(age) gün yaşında napsPerDay: 1 standart bandı değiştirmemelidir")
            XCTAssertNotEqual(withOneNap, WakeWindowBand.months11To14OneNap)
        }

        // predictNextSleep entegrasyonu (12 aylık = 365 gün, tek uyku vs iki uyku)
        let calendar = try makeIstanbulCalendar()
        let predictor = WakeWindowPredictor.standard
        let lastWake = try makeDate(year: 2026, month: 11, day: 16, hour: 8, minute: 0, calendar: calendar)
        let birthDate = try XCTUnwrap(calendar.date(byAdding: .day, value: -365, to: lastWake))

        // napsPerDay: 1 -> bant 270–330 dk (orta = 300), napIndexToday = 0 -> 300 * 0.85 = 255 dk
        // start = max(255 * 0.85 = 216.75, 270) = 270 dk; end = min(255 * 1.15 = 293.25, 330 * 1.15 = 379.5) = 293.25 dk
        let oneNapInterval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [],
            calendar: calendar,
            napsPerDay: 1
        )
        XCTAssertEqual(oneNapInterval.start.timeIntervalSince(lastWake) / 60.0, 270.0, accuracy: 1e-6)
        XCTAssertEqual(oneNapInterval.end.timeIntervalSince(lastWake) / 60.0, 293.25, accuracy: 1e-6)

        // napsPerDay: 2 ve nil aynı sonucu üretir (bant 180–240 dk)
        let twoNapInterval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [],
            calendar: calendar,
            napsPerDay: 2
        )
        let nilNapInterval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(twoNapInterval, nilNapInterval)
        XCTAssertNotEqual(oneNapInterval, twoNapInterval)
    }

    func testBlendingRequiresAtLeastThreeSamplesAndClampsOutliers() throws {
        let calendar = try makeIstanbulCalendar()
        let predictor = WakeWindowPredictor.standard

        // 6 aylık bebek (180 gün): bant 120-180 dk, typicalNaps = 3, base = 150 dk.
        // napIndexToday = 0 -> pozisyon çarpanı = 0.85.
        let lastWake = try makeDate(year: 2026, month: 11, day: 16, hour: 8, minute: 0, calendar: calendar)
        let birthDate = try XCTUnwrap(calendar.date(byAdding: .day, value: -180, to: lastWake))

        // 2 örnek (< 3): harmanlama yapılmaz -> adjusted = 150 * 0.85 = 127.5 dk.
        // Aralık: [max(127.5 * 0.85 = 108.375, 120) = 120, min(127.5 * 1.15 = 146.625, 180 * 1.15 = 207) = 146.625]
        let twoSamplesInterval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [180, 180],
            calendar: calendar
        )
        XCTAssertEqual(twoSamplesInterval.start.timeIntervalSince(lastWake) / 60.0, 120.0, accuracy: 1e-6)
        XCTAssertEqual(twoSamplesInterval.end.timeIntervalSince(lastWake) / 60.0, 146.625, accuracy: 1e-6)

        // 3 örnek (>= 3), uç değer (250 -> 180'e sınırlandırılır): [180, 180, 250] -> sınırlandırılmış ortalama = 180.
        // blended = 0.6 * 150 + 0.4 * 180 = 90 + 72 = 162 dk.
        // napIndexToday = 0 -> adjusted = 162 * 0.85 = 137.7 dk.
        // start = max(137.7 * 0.85 = 117.045, 120) = 120 dk.
        // end = min(137.7 * 1.15 = 158.355, 207) = 158.355 dk.
        let threeSamplesInterval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [180, 180, 250],
            calendar: calendar
        )
        XCTAssertEqual(threeSamplesInterval.start.timeIntervalSince(lastWake) / 60.0, 120.0, accuracy: 1e-6)
        XCTAssertEqual(threeSamplesInterval.end.timeIntervalSince(lastWake) / 60.0, 158.355, accuracy: 1e-6)
    }

    func testPositionFactorAtFirstMiddleAndLastNapAndClamping() throws {
        let calendar = try makeIstanbulCalendar()
        let predictor = WakeWindowPredictor.standard

        // 8 aylık bebek (240 gün): bant 150-210 dk, typicalNaps = 2, base = 180 dk.
        let lastWake = try makeDate(year: 2026, month: 11, day: 16, hour: 9, minute: 0, calendar: calendar)
        let birthDate = try XCTUnwrap(calendar.date(byAdding: .day, value: -240, to: lastWake))

        // İlk uyku (napIndexToday = 0) -> çarpan 0.85 -> adjusted = 153 dk.
        // Ham aralık: [130.05, 175.95] -> alt sınır 150'ye kırpılır -> [150.0, 175.95]
        let firstNap = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 0,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(firstNap.start.timeIntervalSince(lastWake) / 60.0, 150.0, accuracy: 1e-6)
        XCTAssertEqual(firstNap.end.timeIntervalSince(lastWake) / 60.0, 175.95, accuracy: 1e-6)

        // Negatif napIndexToday 0'a kırpılmalı
        let negativeNap = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: -2,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(negativeNap, firstNap)

        // Orta uyku (napIndexToday = 1, typicalNaps = 2) -> çarpan 1.00 -> adjusted = 180 dk.
        // Ham aralık: [180 * 0.85 = 153.0, 180 * 1.15 = 207.0] (sınırlar [150, 241.5] içinde)
        let middleNap = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 1,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(middleNap.start.timeIntervalSince(lastWake) / 60.0, 153.0, accuracy: 1e-6)
        XCTAssertEqual(middleNap.end.timeIntervalSince(lastWake) / 60.0, 207.0, accuracy: 1e-6)

        // Son uyku (napIndexToday = 2 == typicalNaps) -> çarpan 1.15 -> adjusted = 207 dk.
        // Ham aralık: [207 * 0.85 = 175.95, 207 * 1.15 = 238.05] (üst sınır 210 * 1.15 = 241.5 içinde)
        let lastNap = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 2,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(lastNap.start.timeIntervalSince(lastWake) / 60.0, 175.95, accuracy: 1e-6)
        XCTAssertEqual(lastNap.end.timeIntervalSince(lastWake) / 60.0, 238.05, accuracy: 1e-6)

        // typicalNaps üstü napIndexToday typicalNaps'e kırpılmalı
        let overflowNap = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 5,
            recentWakeMinutes: [],
            calendar: calendar
        )
        XCTAssertEqual(overflowNap, lastNap)
    }

    func testUpperClampAtMaxTimes1Point15() throws {
        let calendar = try makeIstanbulCalendar()
        let predictor = WakeWindowPredictor.standard

        // 8 aylık bebek (240 gün): bant 150-210 dk, typicalNaps = 2, base = 180 dk.
        // Gözlenen değerler üst sınırda [210, 210, 210] -> blended = 0.6 * 180 + 0.4 * 210 = 192 dk.
        // Son uyku (napIndexToday = 2) -> adjusted = 192 * 1.15 = 220.8 dk.
        // Ham bitiş: 220.8 * 1.15 = 253.92 dk > 210 * 1.15 (241.5 dk) -> 241.5 dakikaya kırpılmalı.
        let lastWake = try makeDate(year: 2026, month: 11, day: 16, hour: 15, minute: 0, calendar: calendar)
        let birthDate = try XCTUnwrap(calendar.date(byAdding: .day, value: -240, to: lastWake))

        let interval = predictor.predictNextSleep(
            lastWake: lastWake,
            birthDate: birthDate,
            napIndexToday: 2,
            recentWakeMinutes: [210, 210, 210],
            calendar: calendar
        )
        XCTAssertEqual(interval.start.timeIntervalSince(lastWake) / 60.0, 220.8 * 0.85, accuracy: 1e-6)
        XCTAssertEqual(interval.end.timeIntervalSince(lastWake) / 60.0, 210.0 * 1.15, accuracy: 1e-6)
    }
}
