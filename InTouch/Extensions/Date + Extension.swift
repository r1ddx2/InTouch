//
//  Date + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/23.
//

import Foundation

extension Date {
    func minutesRemainingUntilNextMonday() -> TimeInterval {
        let calendar = Calendar.current

        // Calculate the next Monday
        var nextMondayComponents = DateComponents()
        nextMondayComponents.weekday = 2 // Monday
        nextMondayComponents.hour = 0
        nextMondayComponents.minute = 0
        nextMondayComponents.second = 0

        if let nextMonday = calendar.nextDate(after: self, matching: nextMondayComponents, matchingPolicy: .nextTime) {
            // Calculate the time interval between now and the next Monday in minutes
            let minutesRemaining = nextMonday.timeIntervalSince(self) / 60

            // If the next Monday is in the future
            if minutesRemaining >= 0 {
                return minutesRemaining
            }

            // If the next Monday is in the past
            if let nextNextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: nextMonday),
               let minutesRemainingNextNextMonday = calendar.dateComponents([.minute], from: self, to: nextNextMonday).minute
            {
                return Double(minutesRemainingNextNextMonday)
            }
        }
        return 0
    }

    // For each post
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }

    // For each newsletter
    func getThisWeekDateRange() -> String {
        let (startDate, endDate) = calculateDateRange(for: self)
        return "\(formatDate(startDate)) - \(formatDate(endDate))"
    }

    func getLastWeekDateRange() -> String {
        let (startDate, endDate) = calculateDateRange(for: self)
        let calendar = Calendar.current
        let startDateOfLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: startDate)!
        let endDateOfLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: endDate)!
        return "\(formatDate(startDateOfLastWeek)) - \(formatDate(endDateOfLastWeek))"
    }

    func getLastWeekDay() -> Date {
        let (startDate, endDate) = calculateDateRange(for: self)
        let calendar = Calendar.current
        let startDateOfLastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: startDate)!
        return startDateOfLastWeek
    }

    private func calculateDateRange(for date: Date) -> (Date, Date) {
        let calendar = Calendar.current
        let currentWeekday = calendar.component(.weekday, from: date)
        let daysToSubtract = currentWeekday == 1 ? 6 : currentWeekday - 2
        let startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: date)!
        let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
        return (startDate, endDate)
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }

    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}
