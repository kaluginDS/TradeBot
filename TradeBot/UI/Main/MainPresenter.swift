//
//  MainPresenter.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import TinkoffInvestSDK
import Foundation

final class MainPresenter {
    // MARK: - Properties

    weak var view: MainViewInput!
    var interactor: MainInteractorInput!
    var router: MainRouterInput!

    // MARK: - Private properties

    private var graphModule: GraphModule?
    private var testerModule: TesterModule?

    // MARK: - Constants

    private enum Constants {
        enum Strings {
            static let appName: String = "TradeBot"
            static let inputTokenText: String = "Введите api токен:"
            static let inputTokenPlaceholder: String = "Api key"
            static let tokenTypeText: String = "Выберете тип токена:"
            static let doneButtonText: String = "Готово"
        }
    }

    // MARK: - Func

    // MARK: - Private func

    private func getTokenModel() -> TokenViewModel {
        let token: String = AppDataService.shared.token
        let tokenTypes: [String] = [TokenType.test.rawValue, TokenType.prod.rawValue]
        let segmentIndex: Int = tokenTypes.firstIndex(where: {
            $0 == AppDataService.shared.tokenType.rawValue
        }) ?? .zero
        let viewModel: TokenViewModel = TokenViewModel(
            appName: Constants.Strings.appName,
            token: token,
            tokenTypeText: Constants.Strings.tokenTypeText,
            tokenTypes: [TokenType.test.rawValue, TokenType.prod.rawValue],
            segmentIndex: segmentIndex,
            inputTokenText: Constants.Strings.inputTokenText,
            inputTokenPlaceholder: Constants.Strings.inputTokenPlaceholder,
            doneButtonText: Constants.Strings.doneButtonText
        )
        return viewModel
    }
}

// MARK: - MainViewOutput

extension  MainPresenter: MainViewOutput {

    func viewIsReady() {
        if AppDataService.shared.testToken.isEmpty &&
            AppDataService.shared.token.isEmpty {

            let viewModel: TokenViewModel = getTokenModel()
            view.set(tokenModel: viewModel)
            view.showTokenView()
            return
        }
        view.showLoader()
        interactor.getSandboxAccounts()
    }

    func selectTokenType(string: String) {
        let tokenType: TokenType = TokenType(rawValue: string) ?? .test
        AppDataService.shared.tokenType = tokenType
        let token = AppDataService.shared.token
        view.set(token: token)
    }

    func doneButtonDidTouch(token: String) {
        guard !token.isEmpty else {
            return
        }
        switch AppDataService.shared.tokenType {
        case .test:
            AppDataService.shared.testToken = token
        case .prod:
            AppDataService.shared.prodToken = token
        }
        interactor.getSandboxAccounts()
    }
}

// MARK: - MainInteractorOutput

extension MainPresenter: MainInteractorOutput {

    func getSharesSuccess(response: SharesResponse) {
//        let appleShare = response.instruments.first(where: {
//            return $0.name == "Apple"
//        })
//        guard let appleShare = appleShare else {
//            return
//        }
//        let model = StrategyTesterModuleModel(figi: appleShare.figi)
//        tester = StrategyTesterModule(model: model)
//        let strategy = BarUpDownTradeStrategy()
//        tester?.testStrategy(strategy: strategy)
    }

    func getSharesFail(error: Error) {
        print(#function)
        print(error)
        print("---------------------")
    }

    func getSandboxAccountsSuccess(response: GetAccountsResponse) {
        graphModule = router.addGraphModule(
            container: view.graphView,
            in: view.viewController,
            model: GraphModuleModel()
        )
        router.addTradeBotModule(
            container: view.tradeBotView,
            in: view.viewController,
            model: TradeBotModuleModel(output: self)
        )
        testerModule = router.addTesterModule(
            container: view.testerView,
            in: view.viewController,
            model: TesterModuleModel(output: self)
        )

        let strategy = BarUpDownTradeStrategy()
        testerModule?.test(strategy: strategy)

        view.showAppView()
        view.hideLoader()

//        interactor.getShares()
    }

    func getSandboxAccountsFail(error: Error) {
        let tokenModel: TokenViewModel = getTokenModel()
        view.set(tokenModel: tokenModel)
        view.showTokenView()
        view.hideLoader()
        router.showError(error: error)
    }
}

// MARK: -

extension MainPresenter: TradeBotModuleOutput {
    // MARK: - Func

    func testStrategyDidTouch(strategy: TradeStrategyInput) {
        testerModule?.test(strategy: strategy)
    }

    func changeTokenDidTouch() {
        let tokenModel: TokenViewModel = getTokenModel()
        view.set(tokenModel: tokenModel)
        view.showTokenView()
    }
}

// MARK: - TesterModuleOutput

extension MainPresenter: TesterModuleOutput {
    // MARK: - Func

    func testDidComplete(viewModel: GraphContentViewModel) {
        graphModule?.drawGraph(viewModel: viewModel)
    }
}
