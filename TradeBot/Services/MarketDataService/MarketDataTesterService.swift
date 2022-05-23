//
//  MarketDataTesterService.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import Foundation
import TinkoffInvestSDK
import Combine

final class MarketDataTesterService {
    // MARK: - Properties

    weak var output: MarketDataServiceOutput!
    var tinkoffSDK: TinkoffInvestSDK!

    // MARK: - Private properties

    private var candles: [Date: HistoricCandle] = [:]
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Constants

    private enum Constants {
        static let oneStep: Int = 1
    }

    // MARK: - Func

    func setCandles(_ candles: [HistoricCandle]) {
        candles.forEach({
            self.candles[$0.time.date] = $0
        })
    }

    // MARK: - Private func
}

// MARK: - MarketDataServiceInput

extension  MarketDataTesterService: MarketDataServiceInput {
    // MARK: - Func

    func getCandles(
        figi: String,
        from: Date,
        to: Date,
        interval: CandleInterval
    ) {
        var foundedCandles: [HistoricCandle] = []
        var date = from
        while date <= to {
            guard let candle = candles[date] else {
                date = date.adding(interval: interval, step: Constants.oneStep)
                continue
            }
            foundedCandles.append(candle)
            date = date.adding(interval: interval, step: Constants.oneStep)
        }
        var response = GetCandlesResponse()
        response.candles = foundedCandles
        output.getCandlesSuccess(response: response)
    }
}

