//
//  MainModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import TinkoffInvestSDK

struct MainModuleModel {
    
}

final class MainModule {
    // MARK: - Properties

    let view: MainViewController

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    init(model: MainModuleModel) {
        let presenter = MainPresenter()

        view = MainViewController.create()
        view.output = presenter

        let interactor = MainInteractor()
        interactor.output = presenter

        let router = MainRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }

    // MARK: - Private func
}

// MARK: - MainModuleInput

extension  MainModule: MainModuleInput {

}
