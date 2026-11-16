import Foundation

/// Verilen bir ilaç veya takviye dozunun kaydı.
public struct DoseRecord: Sendable, Equatable {
    public let medicationID: String
    public let givenAt: Date

    public init(medicationID: String, givenAt: Date) {
        self.medicationID = medicationID
        self.givenAt = givenAt
    }
}

/// Çift doz koruması kontrol sonucu.
public enum DoseCheck: Sendable, Equatable {
    case allowed
    case tooSoon(nextAllowed: Date)
}

/// Kullanıcı tanımlı asgari doz aralığına göre çift doz korumasını denetleyen kural.
public enum DoseGuard {
    /// İlgili ilacın yalnızca en son verilen dozuna bakarak yeni dozun uygun olup olmadığını denetler.
    /// Asgari süre tam dolduğunda (`at >= nextAllowed`) `.allowed` döner.
    public static func check(
        medicationID: String,
        at date: Date,
        minimumIntervalHours: Double,
        history: [DoseRecord]
    ) -> DoseCheck {
        let latestDose = history
            .filter { $0.medicationID == medicationID }
            .max { $0.givenAt < $1.givenAt }

        guard let latestDose, minimumIntervalHours > 0 else {
            return .allowed
        }

        let nextAllowed = latestDose.givenAt.addingTimeInterval(minimumIntervalHours * 3600.0)
        if date >= nextAllowed {
            return .allowed
        }

        return .tooSoon(nextAllowed: nextAllowed)
    }
}
