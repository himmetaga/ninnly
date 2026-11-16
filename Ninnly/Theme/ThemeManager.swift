import Combine
import Foundation
import NinnlyCore
import SwiftUI
import UIKit

/// Günün saatine göre gece/gündüz fazını ve renk paletini yöneten sınıf.
@MainActor
final class ThemeManager: ObservableObject {
    @Published private(set) var phase: DayPhase

    private let rule: DayPhaseRule
    private let forcedPhase: DayPhase?
    private var transitionTask: Task<Void, Never>?
    private var foregroundObserver: NSObjectProtocol?

    /// Aktif faza karşılık gelen renk paleti.
    var palette: NinnlyPalette {
        switch phase {
        case .night:
            return .night
        case .day:
            return .day
        }
    }

    init(
        rule: DayPhaseRule = .standard,
        arguments: [String] = ProcessInfo.processInfo.arguments
    ) {
        self.rule = rule
        let overridePhase = Self.parseForcedPhase(from: arguments)
        self.forcedPhase = overridePhase

        if let overridePhase {
            self.phase = overridePhase
        } else {
            self.phase = rule.phase(at: Date(), calendar: .current)
            startMonitoring()
        }
    }

    deinit {
        transitionTask?.cancel()
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
    }

    /// Fazı günceller ve bir sonraki geçiş için zamanlayıcıyı yeniden kurar.
    func refresh() {
        guard forcedPhase == nil else { return }

        let now = Date()
        let calendar = Calendar.current
        let newPhase = rule.phase(at: now, calendar: calendar)
        if phase != newPhase {
            phase = newPhase
        }

        scheduleNextTransition(from: now, calendar: calendar)
    }

    /// Ön plana geliş bildirimini dinler ve ilk geçiş zamanlayıcısını başlatır.
    private func startMonitoring() {
        scheduleNextTransition(from: Date(), calendar: .current)

        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.refresh()
            }
        }
    }

    /// Bir sonraki faz geçiş anına kadar bekleyen görev oluşturur.
    private func scheduleNextTransition(from date: Date, calendar: Calendar) {
        transitionTask?.cancel()

        let nextDate = rule.nextTransition(after: date, calendar: calendar)
        let delaySeconds = max(1.0, nextDate.timeIntervalSince(date) + 0.5)
        let nanoseconds = UInt64(delaySeconds * 1_000_000_000)

        transitionTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: nanoseconds)
                guard !Task.isCancelled else { return }
                self?.refresh()
            } catch {
                // Görev iptal edildiğinde ek işlem gerekmez.
            }
        }
    }

    /// Komut satırı argümanlarından "-ninnlyPhase night|day" zorlamasını okur.
    private static func parseForcedPhase(from arguments: [String]) -> DayPhase? {
        guard let flagIndex = arguments.firstIndex(of: "-ninnlyPhase") else {
            return nil
        }
        let valueIndex = arguments.index(after: flagIndex)
        guard valueIndex < arguments.endIndex else {
            return nil
        }
        return DayPhase(rawValue: arguments[valueIndex].lowercased())
    }
}
