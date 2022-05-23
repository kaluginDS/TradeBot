//
//  CGFloat+.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import Foundation

extension CGFloat {
    // MARK: - Properties
    
    var half: CGFloat {
        return self / Constants.Numbers.half
    }

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let half: CGFloat = 2
            static let roundValue: CGFloat = 10
        }
    }

    // MARK: Func

    func format(digits: Digits) -> String {
        let result = round(digits: digits)
        return "\(result)"
    }

    func round(digits: Digits) -> CGFloat {
        let step: CGFloat = pow(Constants.Numbers.roundValue, CGFloat(digits.rawValue))
        let value: CGFloat = self * step
        let result = value.rounded() / step
        return result
    }
}
