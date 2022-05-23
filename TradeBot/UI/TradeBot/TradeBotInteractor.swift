//
//  TradeBotInteractor.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import TinkoffInvestSDK
import Combine
import Foundation

final class TradeBotInteractor {
    // MARK: - Properties

    weak var output: TradeBotInteractorOutput!
    var tinkoffSdk: TinkoffInvestSDK!

    // MARK: - Private properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - TradeBotInteractorInput

extension TradeBotInteractor: TradeBotInteractorInput {
    // MARK: - Func

    func getSandboxAccounts() {
        weak var weakSelf = self

        tinkoffSdk.sandboxService.getSandboxAccounts().sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getSandboxAccounts finished")
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        weakSelf?.output.getSandboxAccountsFail(error: error)
                    })
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async(execute: {
                    weakSelf?.output.getSandboxAccountsSuccess(response: response)
                })
            }
        ).store(in: &cancellables)
    }

    func getSandboxPortfolio(accountID: String) {
        weak var weakSelf = self

        tinkoffSdk.sandboxService.getSandboxPortfolio(accountID: accountID).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getSandboxPortfolio finished")
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        weakSelf?.output.getSandboxPortfolioFail(error: error)
                    })
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async(execute: {
                    weakSelf?.output.getSandboxPortfolioSuccess(accountID: accountID, response: response)
                })
            }
        ).store(in: &cancellables)
    }

    func openSandboxAccount() {
        weak var weakSelf = self

        tinkoffSdk.sandboxService.openSandboxAccount().sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("openSandboxAccount finished")
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        weakSelf?.output.openSandboxAccountFail(error: error)
                    })
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async(execute: {
                    weakSelf?.output.openSandboxAccountSuccess(response: response)
                })
            }
        ).store(in: &cancellables)
    }

    func getTradingSchedules(
        from: Date,
        to: Date
    ) {
        weak var weakSelf = self

        var request = TradingSchedulesRequest()
        request.exchange = GlobalConstants.exchange
        request.from = from.asProtobuf
        request.to = to.asProtobuf
        tinkoffSdk.instrumentsService.getTradingSchedules(request: request).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getTradingSchedules finished")
                case .failure(let error):
                    let message: String = error.trailingMetadata?["message"].first ?? .empty
                    DispatchQueue.main.async {
                        weakSelf?.output.getTradingSchedulesFail(message: message)
                    }
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async {
                    weakSelf?.output.getTradingSchedulesSuccess(response: response)
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

        tinkoffSdk.marketDataService.getCandels(request: request).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getCandles finished")
                case .failure(let error):
                    let message: String = error.trailingMetadata?["message"].first ?? .empty
                    DispatchQueue.main.async {
                        weakSelf?.output.getCandlesFail(message: message)
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

    func postSandboxOrder(
        figi: String,
        quantity: Int,
        price: Quotation,
        direction: OrderDirection,
        accountID: String,
        orderType: OrderType,
        orderID: String
    ) {
        weak var weakSelf = self

        var request = PostOrderRequest()
        request.figi = figi
        request.quantity = Int64(quantity)
        request.price = price
        request.direction = direction
        request.accountID = accountID
        request.orderType = orderType
        request.orderID = orderID

        tinkoffSdk.sandboxService.postSandboxOrder(request: request).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("postSandboxOrder finished")
                case .failure(let error):
                    let message: String = error.trailingMetadata?["message"].first ?? .empty
                    DispatchQueue.main.async {
                        weakSelf?.output.postSandboxOrderFail(message: message)
                    }
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async {
                    weakSelf?.output.postSandboxOrderSuccess(response: response)
                }
            }
        ).store(in: &cancellables)
    }
}
