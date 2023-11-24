//
//  Date + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/23.
//

import Foundation

extension Date {
    // For each post
    func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }

    // For each newsletter
    func getDateRange() -> String {
        let (startDate, endDate) = calculateDateRange(for: self)
        return "\(formatDate(startDate)) - \(formatDate(endDate))"
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
}
