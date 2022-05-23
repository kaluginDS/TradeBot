//
//  MainProtocols.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import Cocoa
import TinkoffInvestSDK
import Combine
import Foundation

// MARK: - MainView

protocol MainViewInput: AnyObject, Presentable, Lodable {
    var tradeBotView: NSView! { get }
    var graphView: NSView! { get }
    var testerView: NSView! { get }

    func showAppView()
    func showTokenView()
    func set(tokenModel: TokenViewModel)
    func set(token: String)
}

protocol MainViewOutput: AnyObject {
    func viewIsReady()
    func selectTokenType(string: String)
    func doneButtonDidTouch(token: String)
}

// MARK: - MainInteractor

protocol MainInteractorInput: AnyObject {
    func getShares()
    func getSandboxAccounts()
}

protocol MainInteractorOutput: AnyObject {
    func getSharesSuccess(response: SharesResponse)
    func getSharesFail(error: Error)

    func getSandboxAccountsSuccess(response: GetAccountsResponse)
    func getSandboxAccountsFail(error: Error)
}

// MARK: - MainRouter

protocol MainRouterInput: AnyObject, Alertable {
    func addGraphModule(
        container: NSView,
        in vc: NSViewController,
        model: GraphModuleModel
    ) -> GraphModule?
    func addTradeBotModule(
        container: NSView,
        in vc: NSViewController,
        model: TradeBotModuleModel
    )
    func addTesterModule(
        container: NSView,
        in vc: NSViewController,
        model: TesterModuleModel
    ) -> TesterModule?
}

// MARK: - MainModule

protocol MainModuleInput: AnyObject {

}

protocol MainModuleOutput: AnyObject {

}
