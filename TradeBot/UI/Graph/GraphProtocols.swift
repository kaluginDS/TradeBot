//
//  GraphProtocols.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import TinkoffInvestSDK
import Foundation

// MARK: - GraphView

protocol GraphViewInput: AnyObject, Presentable {
    func set(viewModel: GraphContentViewModel)
}

protocol GraphViewOutput: AnyObject {
    func viewIsReady()
}

// MARK: - GraphInteractor

protocol GraphInteractorInput: AnyObject {
    func getShares()
    func getCandles(
        figi: String,
        from: Date,
        to: Date,
        interval: CandleInterval
    )
}

protocol GraphInteractorOutput: AnyObject {
    func getSharesSuccess(response: SharesResponse)
    func getSharesFail(error: Error)

    func getCandlesSuccess(response: GetCandlesResponse)
    func getCandlesFail(error: Error)
}

// MARK: - GraphRouter

protocol GraphRouterInput: AnyObject {

}

// MARK: - GraphModule

protocol GraphModuleInput: AnyObject, ChildModule {
    func drawGraph(viewModel: GraphContentViewModel)
}

protocol GraphModuleOutput: AnyObject {

}
