import Foundation

/// Hacim, ağırlık, uzunluk ve sıcaklık birimleri arasında tam katsayılı dönüşümler.
/// Yuvarlama işlemi çağıran katmanın sorumluluğundadır.
public enum Units {
    // MARK: - Tam Dönüşüm Katsayıları (Kaynak: Uluslararası Standart Birim Tanımları)

    /// 1 ABD sıvı onsu (US fl oz) karşılığı mililitre.
    public static let millilitersPerUSFluidOunce = 29.5735295625

    /// 1 libre (lb) karşılığı kilogram.
    public static let kilogramsPerPound = 0.45359237

    /// 1 inç (in) karşılığı santimetre.
    public static let centimetersPerInch = 2.54

    /// Fahrenheit dönüşümü ölçek çarpanı (9 / 5).
    public static let fahrenheitScale = 9.0 / 5.0

    /// Fahrenheit dönüşümü sıfır noktası kayması (32).
    public static let fahrenheitOffset = 32.0

    // MARK: - Hacim (ml <-> US fl oz)

    /// Mililitreyi ABD sıvı onsuna (US fl oz) dönüştürür.
    public static func mlToFluidOunces(_ ml: Double) -> Double {
        ml / millilitersPerUSFluidOunce
    }

    /// ABD sıvı onsunu (US fl oz) mililitreye dönüştürür.
    public static func fluidOuncesToMl(_ fluidOunces: Double) -> Double {
        fluidOunces * millilitersPerUSFluidOunce
    }

    /// Mililitreyi ABD sıvı onsuna (US fl oz) dönüştürür (kısa takma ad).
    public static func mlToOz(_ ml: Double) -> Double {
        mlToFluidOunces(ml)
    }

    /// ABD sıvı onsunu (US fl oz) mililitreye dönüştürür (kısa takma ad).
    public static func ozToMl(_ oz: Double) -> Double {
        fluidOuncesToMl(oz)
    }

    // MARK: - Ağırlık (kg <-> lb)

    /// Kilogramı libreye (lb) dönüştürür.
    public static func kgToPounds(_ kg: Double) -> Double {
        kg / kilogramsPerPound
    }

    /// Libreyi (lb) kilograma dönüştürür.
    public static func poundsToKg(_ pounds: Double) -> Double {
        pounds * kilogramsPerPound
    }

    /// Kilogramı libreye (lb) dönüştürür (kısa takma ad).
    public static func kgToLb(_ kg: Double) -> Double {
        kgToPounds(kg)
    }

    /// Libreyi (lb) kilograma dönüştürür (kısa takma ad).
    public static func lbToKg(_ lb: Double) -> Double {
        poundsToKg(lb)
    }

    // MARK: - Uzunluk (cm <-> in)

    /// Santimetreyi inçe dönüştürür.
    public static func cmToInches(_ cm: Double) -> Double {
        cm / centimetersPerInch
    }

    /// İnçi santimetreye dönüştürür.
    public static func inchesToCm(_ inches: Double) -> Double {
        inches * centimetersPerInch
    }

    /// Santimetreyi inçe dönüştürür (kısa takma ad).
    public static func cmToIn(_ cm: Double) -> Double {
        cmToInches(cm)
    }

    /// İnçi santimetreye dönüştürür (kısa takma ad).
    public static func inToCm(_ inches: Double) -> Double {
        inchesToCm(inches)
    }

    // MARK: - Sıcaklık (°C <-> °F)

    /// Santigrat dereceyi (°C) Fahrenheit dereceye (°F) dönüştürür.
    public static func celsiusToFahrenheit(_ celsius: Double) -> Double {
        celsius * fahrenheitScale + fahrenheitOffset
    }

    /// Fahrenheit dereceyi (°F) Santigrat dereceye (°C) dönüştürür.
    public static func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        (fahrenheit - fahrenheitOffset) / fahrenheitScale
    }
}
