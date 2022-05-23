//
//  MarketDataServiceProtocols.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import Foundation
import TinkoffInvestSDK

protocol MarketDataServiceInput: AnyObject {
    func getCandles(
        figi: String,
        from: Date,
        to: Date,
        interval: CandleInterval
    )
}

protocol MarketDataServiceOutput: AnyObject {
    func getCandlesSuccess(response: GetCandlesResponse)
    func getCandlesFail(error: Error)
}
