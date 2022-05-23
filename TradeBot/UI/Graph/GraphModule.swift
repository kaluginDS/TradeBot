//
//  GraphModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import TinkoffInvestSDK

struct GraphModuleModel {
//    var output: GraphModuleOutput
}

final class GraphModule {
    // MARK: - Properties

    var presentableView: Presentable!

    // MARK: - Private properties

    private let presenter: GraphPresenter

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    init(model: GraphModuleModel) {
        presenter = GraphPresenter()

        let view = GraphViewController.create()
        view.output = presenter
        self.presentableView = view

        let tokenProvider = DefaultTokenProvider(token: GlobalConstants.sandboxToken)
        let sdk = TinkoffInvestSDK(tokenProvider: tokenProvider)

        let interactor = GraphInteractor()
        interactor.output = presenter
        interactor.tinkoffSDK = sdk
        
        let router = GraphRouter()

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
//        presenter.output = model.output
    }

    // MARK: - Private func
}

// MARK: - GraphModuleInput

extension  GraphModule: GraphModuleInput {
    // MARK: Func

    func drawGraph(viewModel: GraphContentViewModel) {
        presenter.drawGraph(viewModel: viewModel)
    }
}
