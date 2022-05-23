//
//  GraphPresenter.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import TinkoffInvestSDK

final class GraphPresenter {
    // MARK: - Properties

    weak var view: GraphViewInput!
    var interactor: GraphInteractorInput!
    var router: GraphRouterInput!
    weak var output: GraphModuleOutput!

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    func drawGraph(viewModel: GraphContentViewModel) {
        view.set(viewModel: viewModel)
    }

    // MARK: - Private func
}

// MARK: - GraphViewOutput

extension GraphPresenter: GraphViewOutput {

    func viewIsReady() {
//        interactor.getShares()
    }
}

// MARK: - GraphInteractorOutput

extension GraphPresenter: GraphInteractorOutput {
    // MARK: - Func

    func getSharesSuccess(response: SharesResponse) {
        let appleShare = response.instruments.first(where: {
            return $0.name == "Apple"
        })
        guard let appleShare = appleShare else {
            return
        }
        interactor.getCandles(
            figi: appleShare.figi,
            from: "01.01.2020".date(),
            to: "01.01.2021".date(),
            interval: .day
        )
    }

    func getSharesFail(error: Error) {
        
    }

    func getCandlesSuccess(response: GetCandlesResponse) {
        let candles: [GraphCandle] = response.candles.map({
            let result = GraphCandle(
                time: $0.time.date,
                open: $0.open.cgFloat,
                close: $0.close.cgFloat,
                low: $0.low.cgFloat,
                high: $0.high.cgFloat,
                mark: .none
            )
            return result
        })
        let viewModel = GraphContentViewModel(candles: candles)
        view.set(viewModel: viewModel)
    }

    func getCandlesFail(error: Error) {
        
    }
}
