import Foundation
import XCTest
@testable import NinnlyCore

/// Emzirme göğüs yönü önerisi ve sağ/sol süre dengesi birim testleri.
final class BreastSideTests: XCTestCase {
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

    func testEmptySessionsDefaultToLeftAndZeroBalance() throws {
        let calendar = try makeIstanbulCalendar()
        let since = try makeDate(hour: 0, minute: 0, calendar: calendar)

        XCTAssertNil(BreastSideAdvisor.lastSide([]))
        XCTAssertEqual(BreastSideAdvisor.suggestedNextSide([]), .left)

        let balance = BreastSideAdvisor.balance([], since: since)
        XCTAssertEqual(balance.leftMinutes, 0)
        XCTAssertEqual(balance.rightMinutes, 0)
    }

    func testLastSideAndSuggestedNextSideWithOverlappingSessions() throws {
        let calendar = try makeIstanbulCalendar()

        // Oturum 1 (sol): 10:00 - 10:25 (daha erken başladı ama daha geç bitti)
        let leftLong = BreastSession(
            side: .left,
            start: try makeDate(hour: 10, minute: 0, calendar: calendar),
            end: try makeDate(hour: 10, minute: 25, calendar: calendar)
        )
        // Oturum 2 (sağ): 10:05 - 10:20 (daha geç başladı ama daha erken bitti)
        let rightShort = BreastSession(
            side: .right,
            start: try makeDate(hour: 10, minute: 5, calendar: calendar),
            end: try makeDate(hour: 10, minute: 20, calendar: calendar)
        )

        // En son biten oturum sol olduğu için lastSide = .left, önerilen sıradaki = .right
        XCTAssertEqual(BreastSideAdvisor.lastSide([leftLong, rightShort]), .left)
        XCTAssertEqual(BreastSideAdvisor.suggestedNextSide([leftLong, rightShort]), .right)

        // Bitiş zamanı tam eşitse daha geç başlayan oturum seçilmeli
        let tieEndLeft = BreastSession(
            side: .left,
            start: try makeDate(hour: 11, minute: 0, calendar: calendar),
            end: try makeDate(hour: 11, minute: 15, calendar: calendar)
        )
        let tieEndRight = BreastSession(
            side: .right,
            start: try makeDate(hour: 11, minute: 5, calendar: calendar),
            end: try makeDate(hour: 11, minute: 15, calendar: calendar)
        )
        XCTAssertEqual(BreastSideAdvisor.lastSide([tieEndLeft, tieEndRight]), .right)
        XCTAssertEqual(BreastSideAdvisor.suggestedNextSide([tieEndLeft, tieEndRight]), .left)
    }

    func testBalanceSinceDateFiltersAndClipsSessions() throws {
        let calendar = try makeIstanbulCalendar()
        let since = try makeDate(hour: 12, minute: 0, calendar: calendar)

        // since öncesinde bitmiş oturum -> 0 dk
        let oldLeft = BreastSession(
            side: .left,
            start: try makeDate(hour: 10, minute: 0, calendar: calendar),
            end: try makeDate(hour: 10, minute: 20, calendar: calendar)
        )

        // since sınırını kesen oturum (11:50 - 12:10) -> yalnız 12:00-12:10 arası (10 dk sol)
        let straddlingLeft = BreastSession(
            side: .left,
            start: try makeDate(hour: 11, minute: 50, calendar: calendar),
            end: try makeDate(hour: 12, minute: 10, calendar: calendar)
        )

        // since sonrasında tam oturumlar (15 dk sol, 18 dk sağ)
        let afternoonLeft = BreastSession(
            side: .left,
            start: try makeDate(hour: 14, minute: 0, calendar: calendar),
            end: try makeDate(hour: 14, minute: 15, calendar: calendar)
        )
        let afternoonRight = BreastSession(
            side: .right,
            start: try makeDate(hour: 14, minute: 15, calendar: calendar),
            end: try makeDate(hour: 14, minute: 33, calendar: calendar)
        )

        let result = BreastSideAdvisor.balance(
            [oldLeft, straddlingLeft, afternoonLeft, afternoonRight],
            since: since
        )
        XCTAssertEqual(result.leftMinutes, 25)
        XCTAssertEqual(result.rightMinutes, 18)
    }
}
