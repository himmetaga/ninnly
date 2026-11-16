import Foundation
import XCTest
@testable import NinnlyCore

/// Gece/gündüz fazı hesaplama ve geçiş zamanı birim testleri.
final class DayPhaseTests: XCTestCase {
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
        hour: Int,
        minute: Int,
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

    func testStandardRuleBoundaries() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = DayPhaseRule.standard

        // 19:59 -> gündüz
        let beforeNight = try makeDate(hour: 19, minute: 59, calendar: calendar)
        XCTAssertEqual(rule.phase(at: beforeNight, calendar: calendar), .day)

        // 20:00 -> gece
        let nightStart = try makeDate(hour: 20, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: nightStart, calendar: calendar), .night)

        // 03:00 -> gece
        let midNight = try makeDate(hour: 3, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: midNight, calendar: calendar), .night)

        // 06:29 -> gece
        let beforeMorning = try makeDate(hour: 6, minute: 29, calendar: calendar)
        XCTAssertEqual(rule.phase(at: beforeMorning, calendar: calendar), .night)

        // 06:30 -> gündüz
        let morningStart = try makeDate(hour: 6, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.phase(at: morningStart, calendar: calendar), .day)

        // 12:00 -> gündüz
        let noon = try makeDate(hour: 12, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: noon, calendar: calendar), .day)
    }

    func testNonWrappingWindow() throws {
        let calendar = try makeIstanbulCalendar()
        // Gece yarısını aşmayan pencere: 01:00 - 05:00
        let rule = DayPhaseRule(nightStartMinute: 1 * 60, nightEndMinute: 5 * 60)

        let at0059 = try makeDate(hour: 0, minute: 59, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at0059, calendar: calendar), .day)

        let at0100 = try makeDate(hour: 1, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at0100, calendar: calendar), .night)

        let at0300 = try makeDate(hour: 3, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at0300, calendar: calendar), .night)

        let at0459 = try makeDate(hour: 4, minute: 59, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at0459, calendar: calendar), .night)

        let at0500 = try makeDate(hour: 5, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at0500, calendar: calendar), .day)

        let at2200 = try makeDate(hour: 22, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: at2200, calendar: calendar), .day)
    }

    func testEqualStartAndEndIsAlwaysDay() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = DayPhaseRule(nightStartMinute: 600, nightEndMinute: 600)

        for hour in 0..<24 {
            let date = try makeDate(hour: hour, minute: 0, calendar: calendar)
            XCTAssertEqual(rule.phase(at: date, calendar: calendar), .day)
        }
    }

    func testOutOfRangeInputsAreNormalized() throws {
        let calendar = try makeIstanbulCalendar()
        // -240 dakika -> 1200 (20:00), 1440 + 390 -> 390 (06:30)
        let rule = DayPhaseRule(nightStartMinute: -240, nightEndMinute: 1440 + 390)

        XCTAssertEqual(rule.nightStartMinute, 20 * 60)
        XCTAssertEqual(rule.nightEndMinute, 6 * 60 + 30)
        XCTAssertEqual(rule, DayPhaseRule.standard)

        let nightDate = try makeDate(hour: 22, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.phase(at: nightDate, calendar: calendar), .night)
    }

    func testNextTransition() throws {
        let calendar = try makeIstanbulCalendar()
        let rule = DayPhaseRule.standard

        // 12:00'dan sonraki geçiş aynı gün 20:00 olmalı
        let noon = try makeDate(day: 16, hour: 12, minute: 0, calendar: calendar)
        let expectedEvening = try makeDate(day: 16, hour: 20, minute: 0, calendar: calendar)
        XCTAssertEqual(rule.nextTransition(after: noon, calendar: calendar), expectedEvening)

        // 23:00'dan sonraki geçiş ertesi gün 06:30 olmalı
        let lateNight = try makeDate(day: 16, hour: 23, minute: 0, calendar: calendar)
        let expectedMorning = try makeDate(day: 17, hour: 6, minute: 30, calendar: calendar)
        XCTAssertEqual(rule.nextTransition(after: lateNight, calendar: calendar), expectedMorning)
    }
}
