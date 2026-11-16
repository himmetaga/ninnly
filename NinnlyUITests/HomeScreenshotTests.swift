import XCTest

/// Gece ve gündüz fazlarında ana ekranı doğrulayan ve ekran görüntüsü alan UI testleri.
final class HomeScreenshotTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testHomeNightScreenshot() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-ninnlyPhase", "night"]
        app.launch()

        let wordmark = app.staticTexts["home.wordmark"]
        XCTAssertTrue(wordmark.waitForExistence(timeout: 10), "Ana ekran başlığı (gece) görünmedi.")

        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "home-night"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testHomeDayScreenshot() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-ninnlyPhase", "day"]
        app.launch()

        let wordmark = app.staticTexts["home.wordmark"]
        XCTAssertTrue(wordmark.waitForExistence(timeout: 10), "Ana ekran başlığı (gündüz) görünmedi.")

        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "home-day"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
