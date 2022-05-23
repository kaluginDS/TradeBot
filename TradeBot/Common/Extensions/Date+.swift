//
//  Date.swift
//  TradeBot
//
//  Created by Денис Калугин on 10.05.2022.
//

import TinkoffInvestSDK
import Foundation

extension Date {

    func beginningOfDay() -> Date? {
        let calendar = NSCalendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month, .day], from: self))
    }

    func startOfWeek() -> Date {
        let calendar = NSCalendar.current
        return calendar.date(from: calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)) ?? Date()
    }

    func adding(
        interval: CandleInterval,
        step: Int
    ) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        switch interval {
        case .unspecified:
            break
        case .candleInterval1Min:
            components.minute = 1 * step
        case .candleInterval5Min:
            components.minute = 5 * step
        case .candleInterval15Min:
            components.minute = 15 * step
        case .hour:
            components.hour = 1 * step
        case .day:
            components.day = 1 * step
        case .UNRECOGNIZED(_):
            break
        }
        let result = calendar.date(byAdding: components, to: self) ?? self
        return result
    }

    func string(dateFormat: String = "dd.MM.yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let string = dateFormatter.string(from: self)
        return string
    }
}
