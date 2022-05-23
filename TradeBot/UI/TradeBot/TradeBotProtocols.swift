//
//  TradeBotProtocols.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import TinkoffInvestSDK
import Cocoa

// MARK: - TradeBotView

protocol TradeBotViewInput: AnyObject, Presentable {
    var output: TradeBotViewOutput? { get set }

    func set(viewModel: TradeBotViewModel)
    func set(tradingModel: TradingViewModel)
}

protocol TradeBotViewOutput: AnyObject {
    func viewIsReady()
    func changeTokenDidTouch()
    func addAccountDidTouch()
    func testStrategyDidTouch(id: String)
    func tradingDidTouch(strategyId: String)
}

// MARK: - TradeBotInteractor

protocol TradeBotInteractorInput: AnyObject {
    func getSandboxAccounts()
    func getSandboxPortfolio(accountID: String)
    func openSandboxAccount()
    func getTradingSchedules(
        from: Date,
        to: Date
    )
    func getCandles(
        figi: String,
        from: Date,
        to: Date,
        interval: CandleInterval
    )
    func postSandboxOrder(
        figi: String,
        quantity: Int,
        price: Quotation,
        direction: OrderDirection,
        accountID: String,
        orderType: OrderType,
        orderID: String
    )
}

protocol TradeBotInteractorOutput: AnyObject {
    func getSandboxAccountsSuccess(response: GetAccountsResponse)
    func getSandboxAccountsFail(error: Error)

    func getSandboxPortfolioSuccess(accountID: String, response: PortfolioResponse)
    func getSandboxPortfolioFail(error: Error)

    func openSandboxAccountSuccess(response: OpenSandboxAccountResponse)
    func openSandboxAccountFail(error: Error)

    func getTradingSchedulesSuccess(response: TradingSchedulesResponse)
    func getTradingSchedulesFail(message: String)

    func getCandlesSuccess(response: GetCandlesResponse)
    func getCandlesFail(message: String)

    func postSandboxOrderSuccess(response: PostOrderResponse)
    func postSandboxOrderFail(message: String)
}

// MARK: - TradeBotRouter

protocol TradeBotRouterInput: AnyObject, Alertable {

}

// MARK: - TradeBotModule

protocol TradeBotModuleInput: AnyObject, ChildModule {
    func showInContainer(container: NSView, in vc: NSViewController)
}

protocol TradeBotModuleOutput: AnyObject {
    func testStrategyDidTouch(strategy: TradeStrategyInput)
    func changeTokenDidTouch()
}
