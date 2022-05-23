//
//  TradeStrategyProtocol.swift
//  TradeBot
//
//  Created by Денис Калугин on 10.05.2022.
//

import Foundation
import TinkoffInvestSDK

protocol TradeStrategyInput: MarketDataServiceOutput {
    var name: String { get }
    var service: MarketDataServiceInput? { get set }

    func getDecision(figi: String, date: Date, completion: @escaping ((_ decision: TradeDirection) -> Void))
}
