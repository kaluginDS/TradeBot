//
//  TradeBotPresenter.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import TinkoffInvestSDK
import Foundation
import AppKit

final class TradeBotPresenter {
    // MARK: - Properties

    weak var view: TradeBotViewInput!
    var interactor: TradeBotInteractorInput!
    var router: TradeBotRouterInput!
    weak var output: TradeBotModuleOutput?
    var accounts: [Account] = []
    var activity: NSBackgroundActivityScheduler!

    // MARK: - Private properties

//    private var accounts: [Account] = []
    private var portfolios: [String: PortfolioResponse] = [:]
    private var strategies: [String: TradeStrategyInput] = [:]
    private var strategyId: String = .empty
    private var activityCompletion: NSBackgroundActivityScheduler.CompletionHandler?

    // MARK: - Constants

    private enum Constants {
        enum Strings {
            static let allMoneyText: String = "Недоступно"
            static let profitText: String = "За все время:"
            static let account: String = "Счёт"
            static let brokerAccount: String = "Брокерский счёт"
            static let issAccount: String = "ИИС счёт"
            static let activeStatusText: String = "Запущен"
            static let inactiveStatusText: String = "Приостановлен"
            static let activeButtonText: String = "Стоп"
            static let inactiveButtonText: String = "Пуск"
        }
        enum Numbers {
            static let tradingTime: TimeInterval = 10
        }
        enum Attributes {
            static let infoAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: Color.grayText
            ]
        }
    }

    // MARK: - Func

    // MARK: - Private func

    private func setViewModel() {
        let accountsViewModels: [AccountsViewModel] = accounts.compactMap({
            guard let portfolio = portfolios[$0.id] else {
                return nil
            }
            let name: String = $0.name.isEmpty ? getAccounNameFrom(type: $0.type) : $0.name

            let result = AccountsViewModel(
                id: $0.id,
                name: name,
                allMoney: Constants.Strings.allMoneyText,
                profitText: Constants.Strings.profitText,
                profitValue: "\(portfolio.expectedYield.asAmount)"
            )
            return result
        })

        let strategy: TradeStrategyInput = BarUpDownTradeStrategy()
        let strategyId: String = UUID().uuidString
        strategies[strategyId] = strategy

        let strategiesViewModel: [StrategiesViewModel] = [
            StrategiesViewModel(
                id: strategyId,
                name: strategy.name
            )
        ]

        let tradingViewModel: TradingViewModel = TradingViewModel(
            statusText: Constants.Strings.inactiveStatusText,
            tradingButtonText: Constants.Strings.inactiveButtonText
        )

        let tokenTypeText: NSAttributedString = NSAttributedString(
            string: AppDataService.shared.tokenType.rawValue,
            attributes: Constants.Attributes.infoAttributes
        )

        let viewModel = TradeBotViewModel(
            tokenTypeText: tokenTypeText,
            accounts: accountsViewModels,
            strategies: strategiesViewModel,
            trading: tradingViewModel
        )
        view.set(viewModel: viewModel)
    }

    private func getAccounNameFrom(type: AccountType) -> String {
        let result: String
        switch type {
        case .unspecified:
            result = Constants.Strings.account
        case .tinkoff:
            result = Constants.Strings.brokerAccount
        case .tinkoffIis:
            result = Constants.Strings.issAccount
        case .investBox:
            result = Constants.Strings.account
        case .UNRECOGNIZED(_):
            result = Constants.Strings.account
        }
        return result
    }
}

// MARK: - TradeBotViewOutput

extension TradeBotPresenter: TradeBotViewOutput {

    func viewIsReady() {
        interactor.getSandboxAccounts()
    }

    func changeTokenDidTouch() {
        output?.changeTokenDidTouch()
    }

    func addAccountDidTouch() {
        interactor.openSandboxAccount()
    }

    func testStrategyDidTouch(id: String) {
        guard let strategy = strategies[id] else {
            return
        }
        output?.testStrategyDidTouch(strategy: strategy)
    }

    func tradingDidTouch(strategyId: String) {
        weak var weakSelf = self

//        let from: Date = Date()
//        let to: Date = from.adding(interval: .day, step: 3)
//
//        print("from: \(from)")
//        print("to: \(to)")
//        interactor.getTradingSchedules(
//            from: from,
//            to: to,
//            success: { response in
//                print(response)
//            },
//            fail: { message in
//                weakSelf?.router.showError(message: message)
//            }
//        )
//        return

        print("\(Date()) trading start")
        activity.schedule { completion in
            weakSelf?.activityCompletion = completion

            let to = Date()
            let from = Date().adding(interval: GlobalConstants.interval, step: -1)
            print("from: \(from)")
            print("to: \(to)")
            weakSelf?.interactor.getCandles(
                figi: GlobalConstants.figi,
                from: from,
                to: to,
                interval: GlobalConstants.interval
            )
        }
    }
}

// MARK: - TradeBotInteractorOutput

extension TradeBotPresenter: TradeBotInteractorOutput {
    func getSandboxAccountsSuccess(response: GetAccountsResponse) {
        accounts = response.accounts
        accounts.forEach({
            interactor.getSandboxPortfolio(accountID: $0.id)
        })

        if accounts.isEmpty {
            setViewModel()
        }
    }

    func getSandboxAccountsFail(error: Error) {

    }

    func getSandboxPortfolioSuccess(accountID: String, response: PortfolioResponse) {
        portfolios[accountID] = response

        if portfolios.count == accounts.count {
            setViewModel()
        }
    }

    func getSandboxPortfolioFail(error: Error) {

    }

    func openSandboxAccountSuccess(response: OpenSandboxAccountResponse) {
        interactor.getSandboxAccounts()
    }

    func openSandboxAccountFail(error: Error) {
        
    }

    func getTradingSchedulesSuccess(response: TradingSchedulesResponse) {

    }

    func getTradingSchedulesFail(message: String) {
        router.showError(message: message)
    }

    func getCandlesSuccess(response: GetCandlesResponse) {
        let candles = response.candles
        guard let lastCandle = response.candles.last else {
            return
        }
        let currentSeconds = Date().timeIntervalSince1970
        let candleSeconds = lastCandle.time.date.timeIntervalSince1970
        let difference = currentSeconds - candleSeconds

        if difference < Constants.Numbers.tradingTime {
            guard let penultimateCandle = candles[safe: candles.count - 2],
                  let strategy = strategies[strategyId],
                  let account = accounts.first else {
                return
            }
            weak var weakSelf = self
            let completion: ((TradeDirection) -> Void) = { decision in
                let direction: OrderDirection
                switch decision {
                case .unspecified:
                    return
                case .buy:
                    direction = .buy
                case .sell:
                    direction = .sell
                case .UNRECOGNIZED(_):
                    return
                }

                weakSelf?.interactor.postSandboxOrder(
                    figi: GlobalConstants.figi,
                    quantity: GlobalConstants.quantity,
                    price: lastCandle.close,
                    direction: direction,
                    accountID: account.id,
                    orderType: .market,
                    orderID: "0"
                )
            }
            strategy.getDecision(
                figi: GlobalConstants.figi,
                date: penultimateCandle.time.date,
                completion: completion
            )
        } else {

        }
    }

    func getCandlesFail(message: String) {
        router.showError(message: message)
    }

    func postSandboxOrderSuccess(response: PostOrderResponse) {

    }

    func postSandboxOrderFail(message: String) {
        router.showError(message: message)
    }
}
