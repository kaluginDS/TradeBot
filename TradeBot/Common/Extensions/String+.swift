//
//  String+.swift
//  TradeBot
//
//  Created by Денис Калугин on 10.05.2022.
//

import Foundation

extension String {

    static let empty: String = ""

    func date(dateFormat: String = "dd.MM.yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
}
