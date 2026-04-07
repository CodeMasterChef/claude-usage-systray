import Foundation

struct AppSettings: Codable {
    var warningThreshold: Double = 80.0
    var criticalThreshold: Double = 90.0
    var notificationsEnabled: Bool = true
    var compactDisplay: Bool = true
    var refreshIntervalSeconds: Double = 120

    var isConfigured: Bool { true }
}

struct UsageSnapshot {
    let fiveHourUtilization: Int
    let sevenDayUtilization: Int
    let sevenDaySonnetUtilization: Int?
    let fiveHourResetIn: String?
    let sevenDayResetIn: String?
    let fiveHourResetAt: Date?
    let sevenDayResetAt: Date?
    let lastUpdated: Date
    let weeklySessions: Int
    let weeklyMessages: Int
    let weeklyTokens: Int

    var displayText: String { "\(sevenDayUtilization)%" }
    var menuBarPrimaryText: String { "5hr: \(fiveHourUtilization)%" }
    var menuBarSecondaryText: String { "Week: \(sevenDayUtilization)%" }

    /// Formats a reset date as local time, e.g. "Resets 4pm" or "Resets Apr 10 at 10:59am"
    static func formatResetTime(_ date: Date?) -> String? {
        guard let date else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let tz = TimeZone.current

        let formatter = DateFormatter()
        formatter.timeZone = tz
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let seconds = tz.secondsFromGMT()
        let hours = seconds / 3600
        let mins = abs(seconds % 3600) / 60
        let gmtOffset = mins == 0 ? "GMT\(hours >= 0 ? "+" : "")\(hours)" : "GMT\(hours >= 0 ? "+" : "")\(hours):\(String(format: "%02d", mins))"

        if calendar.isDate(date, inSameDayAs: now) {
            formatter.dateFormat = "h:mma"
            return "\(formatter.string(from: date)) \(gmtOffset)"
        } else {
            formatter.dateFormat = "EEEE, MMM d h:mma"
            return "\(formatter.string(from: date)) \(gmtOffset)"
        }
    }

    static var placeholder: UsageSnapshot {
        UsageSnapshot(
            fiveHourUtilization: 0,
            sevenDayUtilization: 0,
            sevenDaySonnetUtilization: nil,
            fiveHourResetIn: nil,
            sevenDayResetIn: nil,
            fiveHourResetAt: nil,
            sevenDayResetAt: nil,
            lastUpdated: Date(),
            weeklySessions: 0,
            weeklyMessages: 0,
            weeklyTokens: 0
        )
    }
}
