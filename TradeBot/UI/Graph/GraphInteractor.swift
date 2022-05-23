//
//  GraphInteractor.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import TinkoffInvestSDK
import Combine
import Foundation

final class GraphInteractor {
    // MARK: - Properties

    weak var output: GraphInteractorOutput!

    // MARK: - Private properties

    private var cancellables = Set<AnyCancellable>()
    var tinkoffSDK: TinkoffInvestSDK!

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - GraphInteractorInput

extension  GraphInteractor: GraphInteractorInput {
    // MARK: - Func

    func getShares() {
        weak var weakSelf = self

        tinkoffSDK.instrumentsService.getShares(with: .base).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getShares finished")
                case .failure(let error):
                    DispatchQueue.main.async {
                        weakSelf?.output.getSharesFail(error: error)
                    }
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async {
                    weakSelf?.output.getSharesSuccess(response: response)
                }
            }
        ).store(in: &cancellables)
    }

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
                    DispatchQueue.main.async {
                        weakSelf?.output.getCandlesFail(error: error)
                    }
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async {
                    weakSelf?.output.getCandlesSuccess(response: response)
                }
            }
        ).store(in: &cancellables)
    }
}
