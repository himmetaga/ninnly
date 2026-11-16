import Foundation
import XCTest
@testable import NinnlyCore

/// Birim dönüşüm katsayıları ve çift yönlü dönüşüm hassasiyeti testleri.
final class UnitsTests: XCTestCase {
    func testExactConversionFactors() {
        XCTAssertEqual(Units.fluidOuncesToMl(1.0), 29.5735295625, accuracy: 1e-12)
        XCTAssertEqual(Units.mlToFluidOunces(29.5735295625), 1.0, accuracy: 1e-12)

        XCTAssertEqual(Units.poundsToKg(1.0), 0.45359237, accuracy: 1e-12)
        XCTAssertEqual(Units.kgToPounds(0.45359237), 1.0, accuracy: 1e-12)

        XCTAssertEqual(Units.inchesToCm(1.0), 2.54, accuracy: 1e-12)
        XCTAssertEqual(Units.cmToInches(2.54), 1.0, accuracy: 1e-12)

        XCTAssertEqual(Units.celsiusToFahrenheit(0.0), 32.0, accuracy: 1e-12)
        XCTAssertEqual(Units.celsiusToFahrenheit(100.0), 212.0, accuracy: 1e-12)
        XCTAssertEqual(Units.celsiusToFahrenheit(-40.0), -40.0, accuracy: 1e-12)
        XCTAssertEqual(Units.fahrenheitToCelsius(98.6), 37.0, accuracy: 1e-9)
    }

    func testRoundTripsWithin1eMinus9() {
        let mlSamples = [0.0, 15.0, 90.0, 125.5, 250.0]
        for ml in mlSamples {
            let roundTrip = Units.fluidOuncesToMl(Units.mlToFluidOunces(ml))
            XCTAssertEqual(roundTrip, ml, accuracy: 1e-9)
            XCTAssertEqual(Units.ozToMl(Units.mlToOz(ml)), ml, accuracy: 1e-9)
        }

        let kgSamples = [0.0, 2.5, 3.45, 7.8, 12.345]
        for kg in kgSamples {
            let roundTrip = Units.poundsToKg(Units.kgToPounds(kg))
            XCTAssertEqual(roundTrip, kg, accuracy: 1e-9)
            XCTAssertEqual(Units.lbToKg(Units.kgToLb(kg)), kg, accuracy: 1e-9)
        }

        let cmSamples = [0.0, 35.0, 50.2, 68.5, 85.75]
        for cm in cmSamples {
            let roundTrip = Units.inchesToCm(Units.cmToInches(cm))
            XCTAssertEqual(roundTrip, cm, accuracy: 1e-9)
            XCTAssertEqual(Units.inToCm(Units.cmToIn(cm)), cm, accuracy: 1e-9)
        }

        let celsiusSamples = [-40.0, 0.0, 36.5, 37.8, 39.2, 100.0]
        for celsius in celsiusSamples {
            let roundTrip = Units.fahrenheitToCelsius(Units.celsiusToFahrenheit(celsius))
            XCTAssertEqual(roundTrip, celsius, accuracy: 1e-9)
        }
    }
}
