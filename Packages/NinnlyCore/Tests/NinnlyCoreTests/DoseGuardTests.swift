import Foundation
import XCTest
@testable import NinnlyCore

/// İlaç çift doz koruması birim testleri.
final class DoseGuardTests: XCTestCase {
    /// Sabit Europe/Istanbul saat dilimli Miladi takvim oluşturur.
    private func makeIstanbulCalendar() throws -> Calendar {
        let timeZone = try XCTUnwrap(TimeZone(identifier: "Europe/Istanbul"))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }

    /// Yardımcı tarih oluşturucu.
    private func makeDate(
        day: Int = 16,
        hour: Int,
        minute: Int,
        second: Int = 0,
        calendar: Calendar
    ) throws -> Date {
        let components = DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: 2026,
            month: 11,
            day: day,
            hour: hour,
            minute: minute,
            second: second
        )
        return try XCTUnwrap(calendar.date(from: components))
    }

    func testAllowedWhenNoMatchingHistoryExists() throws {
        let calendar = try makeIstanbulCalendar()
        let now = try makeDate(hour: 12, minute: 0, calendar: calendar)
        let otherMed = DoseRecord(
            medicationID: "vitamin-d",
            givenAt: try makeDate(hour: 11, minute: 30, calendar: calendar)
        )

        XCTAssertEqual(
            DoseGuard.check(medicationID: "paracetamol", at: now, minimumIntervalHours: 4.0, history: []),
            .allowed
        )
        XCTAssertEqual(
            DoseGuard.check(medicationID: "paracetamol", at: now, minimumIntervalHours: 4.0, history: [otherMed]),
            .allowed
        )
    }

    func testUsesLatestDoseAndBoundaryAtExactIntervalIsAllowed() throws {
        let calendar = try makeIstanbulCalendar()
        let earlierDose = DoseRecord(
            medicationID: "paracetamol",
            givenAt: try makeDate(hour: 6, minute: 0, calendar: calendar)
        )
        let latestDose = DoseRecord(
            medicationID: "paracetamol",
            givenAt: try makeDate(hour: 10, minute: 0, calendar: calendar)
        )
        let otherMedLatest = DoseRecord(
            medicationID: "ibuprofen",
            givenAt: try makeDate(hour: 11, minute: 0, calendar: calendar)
        )

        // Sırasız geçmiş listesi
        let history = [latestDose, otherMedLatest, earlierDose]
        let expectedNextAllowed = try makeDate(hour: 14, minute: 0, second: 0, calendar: calendar)

        // 13:59:59 -> henüz erken (.tooSoon)
        let oneSecondBefore = try makeDate(hour: 13, minute: 59, second: 59, calendar: calendar)
        XCTAssertEqual(
            DoseGuard.check(
                medicationID: "paracetamol",
                at: oneSecondBefore,
                minimumIntervalHours: 4.0,
                history: history
            ),
            .tooSoon(nextAllowed: expectedNextAllowed)
        )

        // 14:00:00 -> tam sınırda (.allowed)
        XCTAssertEqual(
            DoseGuard.check(
                medicationID: "paracetamol",
                at: expectedNextAllowed,
                minimumIntervalHours: 4.0,
                history: history
            ),
            .allowed
        )

        // 14:15:00 -> sınır sonrasında (.allowed)
        let afterInterval = try makeDate(hour: 14, minute: 15, second: 0, calendar: calendar)
        XCTAssertEqual(
            DoseGuard.check(
                medicationID: "paracetamol",
                at: afterInterval,
                minimumIntervalHours: 4.0,
                history: history
            ),
            .allowed
        )
    }
}
