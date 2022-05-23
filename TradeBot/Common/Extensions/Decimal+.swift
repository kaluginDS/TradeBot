//
//  Decimal+.swift
//  TradeBot
//
//  Created by Денис Калугин on 20.05.2022.
//

import Foundation

enum Digits: Int {
    case noDigits = 0
    case oneDigits = 1
    case twoDigits = 2
}

extension Decimal {

    func format(digits: Digits) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .halfEven
        numberFormatter.maximumFractionDigits = digits.rawValue

        let number = NSDecimalNumber(decimal: self)
        let result = numberFormatter.string(from: number)
        return result ?? "\(self)"
    }
}
