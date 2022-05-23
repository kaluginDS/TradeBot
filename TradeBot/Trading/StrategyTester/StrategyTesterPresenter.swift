//
//  StrategyTesterPresenter.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import Foundation
import TinkoffInvestSDK

final class TBTrade {
    var startTrade: Trade
    var startCandleIndex: Int
    var endTrade: Trade?
    var endCandleIndex: Int?

    init(startTrade: Trade, startCandleIndex: Int) {
        self.startTrade = startTrade
        self.startCandleIndex = startCandleIndex
    }
}

final class StrategyTesterPresenter {
    // MARK: - Properties

    weak var output: StrategyTesterModuleOutput?
    var figi: String!
    var service: MarketDataServiceInput!

    // MARK: - Private properties

    private var date: Date!
    private var candles: [HistoricCandle] = []
    private var candle: HistoricCandle!
    private var candleIndex: Int!
    private var strategy: TradeStrategyInput!
    private var trades: [TBTrade] = []
    private var strategyService: MarketDataTesterService?

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let oneHundredPercent: Decimal = 100
            static let nextIndex: Int = 1
        }
    }

    // MARK: - Func

    func testStrategy(strategy: (TradeStrategyInput)) {
        let strategyService = MarketDataTesterService()
        strategyService.output = strategy

        strategy.service = strategyService
        self.strategy = strategy
        self.strategyService = strategyService

        service.getCandles(
            figi: figi,
            from: "01.01.2020".date(),
            to: "01.01.2021".date(),
            interval: .day
        )
    }

    // MARK: - Private func

    private func getCandleMark(from direction: TradeDirection) -> CandleMark {
        switch direction {
        case .unspecified:
            return .none
        case .buy:
            return .enter
        case .sell:
            return .leave
        case .UNRECOGNIZED(_):
            return .none
        }
    }
}

// MARK: - MarketDataServiceOutput

extension StrategyTesterPresenter: MarketDataServiceOutput {
    // MARK: - Func

    func getCandlesSuccess(response: GetCandlesResponse) {
        let candles = response.candles
        self.candles = candles
        strategyService?.setCandles(candles)

        var graphCandles: [GraphCandle] = candles.map({
            let result: GraphCandle = GraphCandle(
                time: $0.time.date,
                open: $0.open.cgFloat,
                close: $0.close.cgFloat,
                low: $0.low.cgFloat,
                high: $0.high.cgFloat,
                mark: .none
            )
            return result
        })

        for (i, candle) in candles.enumerated() {
            self.candle = candle
            self.candleIndex = i

            strategy.getDecision(figi: figi, date: candle.time.date, completion: { [weak self] decision in
                guard let strongSelf = self,
                      decision != .unspecified,
                      let nextCandle = candles[safe: i + Constants.Numbers.nextIndex] else {
                    return
                }

                let candleMark: CandleMark

                let lastTrade = strongSelf.trades.last
                let isFirstTrade: Bool = lastTrade == nil
                let isStartTrade: Bool = lastTrade?.endTrade != nil

                if isFirstTrade || isStartTrade,
                   decision == .buy {

                    var startTrade = Trade()
                    startTrade.figi = strongSelf.figi
                    startTrade.time = nextCandle.time
                    startTrade.direction = decision
                    startTrade.price = nextCandle.open

                    let tbTrade = TBTrade(
                        startTrade: startTrade,
                        startCandleIndex: i + Constants.Numbers.nextIndex
                    )
                    strongSelf.trades.append(tbTrade)

                    candleMark = .enter
                } else if !isFirstTrade && !isStartTrade,
                          decision == .sell {

                    var endTrade = Trade()
                    endTrade.figi = strongSelf.figi
                    endTrade.time = nextCandle.time
                    endTrade.direction = decision
                    endTrade.price = nextCandle.open

                    lastTrade?.endTrade = endTrade
                    lastTrade?.endCandleIndex = i

                    candleMark = .leave
                } else {
                    candleMark = .none
                }

                graphCandles[i + Constants.Numbers.nextIndex] = GraphCandle(
                    time: nextCandle.time.date,
                    open: nextCandle.open.cgFloat,
                    close: nextCandle.close.cgFloat,
                    low: nextCandle.low.cgFloat,
                    high: nextCandle.high.cgFloat,
                    mark: candleMark
                )
            })
        }

        var profit: Decimal = 1000
        trades.forEach({
            guard let endPrice = $0.endTrade?.price.asAmount else {
                return
            }
            let startPrice = $0.startTrade.price.asAmount
            let profitPercent = endPrice * Constants.Numbers.oneHundredPercent / startPrice - Constants.Numbers.oneHundredPercent
            let difference = profit / Constants.Numbers.oneHundredPercent * profitPercent
            print(profitPercent)
            profit += difference
        })
//        print("profit: \(profit)")
//        print("profit in percent: \(profit * 100 / 1000 - 100)")
        let model: StrategyTesterModuleOutputModel = StrategyTesterModuleOutputModel(
            trades: trades,
            candles: graphCandles
        )
        output?.testCompleted(model: model)
    }

    func getCandlesFail(error: Error) {

    }
}
