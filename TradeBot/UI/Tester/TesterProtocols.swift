//
//  TesterProtocols.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

// MARK: - TesterView

protocol TesterViewInput: AnyObject, Presentable, Lodable {
    func set(viewModel: TesterViewControllerModel)
}

protocol TesterViewOutput: AnyObject {
    func viewIsReady()
}

// MARK: - TesterInteractor

protocol TesterInteractorInput: AnyObject {

}

protocol TesterInteractorOutput: AnyObject {

}

// MARK: - TesterRouter

protocol TesterRouterInput: AnyObject {

}

// MARK: - TesterModule

protocol TesterModuleInput: AnyObject, ChildModule {
    func test(strategy: TradeStrategyInput)
}

protocol TesterModuleOutput: AnyObject {
    func testDidComplete(viewModel: GraphContentViewModel)
}
