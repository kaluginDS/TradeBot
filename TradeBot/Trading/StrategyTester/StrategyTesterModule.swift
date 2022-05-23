//
//  StrategyTesterModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 14.05.2022.
//

import TinkoffInvestSDK

struct StrategyTesterModuleModel {
    let figi: String
    let output: StrategyTesterModuleOutput?
}

struct StrategyTesterModuleOutputModel {
    let trades: [TBTrade]
    let candles: [GraphCandle]
}

final class StrategyTesterModule {
    // MARK: - Properties

    let presenter: StrategyTesterPresenter

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    init(model: StrategyTesterModuleModel) {
        presenter = StrategyTesterPresenter()

        let tokenProvider = DefaultTokenProvider(token: GlobalConstants.sandboxToken)
        let tinkoffSDK = TinkoffInvestSDK(tokenProvider: tokenProvider)
        let service = MarketDataService()
        service.tinkoffSDK = tinkoffSDK
        service.output = presenter

        presenter.service = service
        presenter.figi = model.figi
        presenter.output = model.output
    }

    // MARK: - Private func
}

// MARK: - StrategyTesterModuleInput

extension  StrategyTesterModule: StrategyTesterModuleInput {
    // MARK: - Func

    func testStrategy(strategy: (TradeStrategyInput)) {
        presenter.testStrategy(strategy: strategy)
    }
}
