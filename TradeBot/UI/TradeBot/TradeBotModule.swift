//
//  TradeBotModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import AppKit
import TinkoffInvestSDK

struct TradeBotModuleModel {
    let output: TradeBotModuleOutput
}

final class TradeBotModule {
    // MARK: - Properties

    var presentableView: Presentable!

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {
        enum Strings {
            static let activityId: String = "com.TradeBot.trading"
        }
    }

    // MARK: - Func

    init(model: TradeBotModuleModel) {
        let presenter = TradeBotPresenter()

        let view = TradeBotViewController.create()
        view.output = presenter
        presentableView = view

        let tokenProvider = DefaultTokenProvider(token: AppDataService.shared.token)
        let sdk = TinkoffInvestSDK(tokenProvider: tokenProvider)

        let interactor = TradeBotInteractor()
        interactor.output = presenter
        interactor.tinkoffSdk = sdk
        
        let router = TradeBotRouter()

        let activity = NSBackgroundActivityScheduler(identifier: Constants.Strings.activityId)
        activity.repeats = true
        activity.interval = 5

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.output = model.output
        presenter.activity = activity
    }

    // MARK: - Private func
}

// MARK: - TradeBotModuleInput

extension TradeBotModule: TradeBotModuleInput {

}
