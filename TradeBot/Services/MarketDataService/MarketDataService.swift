//
//  MarketDataService.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import Foundation
import TinkoffInvestSDK
import Combine

final class MarketDataService {
    // MARK: - Properties

    weak var output: MarketDataServiceOutput!
    var tinkoffSDK: TinkoffInvestSDK!

    // MARK: - Private properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - MarketDataServiceInput

extension  MarketDataService: MarketDataServiceInput {
    // MARK: - Func

    func getCandles(
        figi: String,
        from: Date,
        to: Date,
        interval: CandleInterval
    ) {
        weak var weakSelf = self

        var request = GetCandlesRequest()
        request.figi = figi
        request.from = from.asProtobuf
        request.to = to.asProtobuf
        request.interval = interval

        tinkoffSDK.marketDataService.getCandels(request: request).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getCandles finished")
                case .failure(let error):
                    weakSelf?.output.getCandlesFail(error: error)
                }
            },
            receiveValue: { response in
                weakSelf?.output.getCandlesSuccess(response: response)
            }
        ).store(in: &cancellables)
    }
}
