//
//  BarUpDownTradeStrategy.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import Foundation
import TinkoffInvestSDK
import Combine

final class BarUpDownTradeStrategy {
    // MARK: - Properties

    var name: String { return "BarUpDown" }
    var service: MarketDataServiceInput?

    // MARK: - Private properties

    private var date: Date = Date()
    private var completion: ((_ decision: TradeDirection) -> Void)?

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - TradeStrategyInput

extension BarUpDownTradeStrategy: TradeStrategyInput {
    // MARK: - Func

    func getDecision(figi: String, date: Date, completion: @escaping ((_ decision: TradeDirection) -> Void)) {
        self.date = date
        self.completion = completion
        let previousDate = date.adding(interval: .day, step: -1)
        service?.getCandles(
            figi: figi,
            from: previousDate,
            to: date,
            interval: .day
        )
    }
}

// MARK: - MarketDataServiceOutput

extension BarUpDownTradeStrategy: MarketDataServiceOutput {
    // MARK: - Func

    func getCandlesSuccess(response: GetCandlesResponse) {
        let candles = response.candles

        guard let previousCandle = candles[safe: 0],
              let candle = candles[safe: 1] else {
            completion?(.unspecified)
            return
        }

        let isGreen = candle.open.asAmount < candle.close.asAmount
        let openMoreThanPreviousClose = candle.open.asAmount > previousCandle.close.asAmount

        let isRed = candle.open.asAmount > candle.close.asAmount
        let openLessThanPreviousClose = candle.open.asAmount < previousCandle.close.asAmount

        if isGreen && openMoreThanPreviousClose {
            completion?(.buy)
        } else if isRed && openLessThanPreviousClose {
            completion?(.sell)
        } else {
            completion?(.unspecified)
        }
    }

    func getCandlesFail(error: Error) {
        completion?(.unspecified)
    }
}
