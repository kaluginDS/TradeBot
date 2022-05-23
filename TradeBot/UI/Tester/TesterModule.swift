//
//  TesterModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

struct TesterModuleModel {
    var output: TesterModuleOutput
}

final class TesterModule {
    // MARK: - Properties

    var presentableView: Presentable!

    // MARK: - Private properties

    private let presenter: TesterPresenter

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    init(model: TesterModuleModel) {
        presenter = TesterPresenter()

        let view = TesterViewController.create()
        presentableView = view
        view.output = presenter

        let interactor = TesterInteractor()
        interactor.output = presenter
        
        let router = TesterRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.output = model.output
    }

    // MARK: - Private func
}

// MARK: - TesterModuleInput

extension TesterModule: TesterModuleInput {
    // MARK: - Func

    func test(strategy: TradeStrategyInput) {
        presenter.test(strategy: strategy)
    }
}
