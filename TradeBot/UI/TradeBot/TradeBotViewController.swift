//
//  TradeBotViewController.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import Cocoa

struct TradeBotViewModel {
    let tokenTypeText: NSAttributedString
    let accounts: [AccountsViewModel]
    let strategies: [StrategiesViewModel]
    let trading: TradingViewModel
}

struct AccountsViewModel {
    let id: String
    let name: String
    let allMoney: String
    let profitText: String
    let profitValue: String
}

struct StrategiesViewModel {
    let id: String
    let name: String
}

struct TradingViewModel {
    let statusText: String
    let tradingButtonText: String
}

final class TradeBotViewController: NSViewController, ViewControllerable {
    // MARK: - Properties

    var output: TradeBotViewOutput?

    // MARK: - Private properties

    @IBOutlet private weak var noAccountsView: NSView!
    @IBOutlet private weak var controlView: NSStackView!

    @IBOutlet private weak var noAccountsLabel: NSTextField!
    @IBOutlet private weak var addAccountButton: Button!

    @IBOutlet private weak var tokenLabel: NSTextField!
    @IBOutlet private weak var tokenTypeLabel: NSTextField!
    @IBOutlet private weak var changeTokenButton: Button!

    @IBOutlet private weak var accountsButton: NSPopUpButton!
    @IBOutlet private weak var allMoneyLabel: NSTextField!
    @IBOutlet private weak var profitLabel: NSTextField!
    @IBOutlet private weak var profitValueLabel: NSTextField!

    @IBOutlet private weak var strategyLabel: NSTextField!
    @IBOutlet private weak var strategiesButton: NSPopUpButton!
    @IBOutlet private weak var testStrategyButton: Button!

    @IBOutlet private weak var statusLabel: NSTextField!
    @IBOutlet private weak var statusValueLabel: NSTextField!
    @IBOutlet private weak var tradingButton: Button!

    private var viewModel: TradeBotViewModel?

    // MARK: - Constants

    private enum Constants {
        enum Strings {
            static let noAccountsText: String = "У Вас нет аккаунта"
            static let addAccountText: String = "Создать"
            static let tokenText: String = "Тип токена:"
            static let changeTokenText: String = "Смeнить токен"
            static let strategyText: String = "Стратегия:"
            static let testText: String = "Тест"
            static let statusText: String = "Статус робота:"
        }
        enum Attributes {
            static let accountPopUpAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: Color.blueText
            ]
            static let popUpAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: Color.blueText
            ]
        }
    }

    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = Color.background.cgColor

        controlView.isHidden = false
        noAccountsView.isHidden = true

        setupNoAccountsView()
        setupAccountView()
        setupTokenView()
        setupTesterView()
        setupTradingView()

        output?.viewIsReady()
    }

    // MARK: - Private func

    private func setupNoAccountsView() {
        noAccountsLabel.stringValue = Constants.Strings.noAccountsText
        addAccountButton.setTitle(Constants.Strings.addAccountText)
    }

    private func setupTokenView() {
        tokenLabel.stringValue = Constants.Strings.tokenText
        changeTokenButton.setTitle(Constants.Strings.changeTokenText)
    }

    private func setupAccountView() {
        accountsButton.contentTintColor = Color.blueText
    }

    private func setupTesterView() {
        strategyLabel.stringValue = Constants.Strings.strategyText
        strategiesButton.contentTintColor = Color.blueText
        testStrategyButton.setTitle(Constants.Strings.testText)
    }

    private func setupTradingView() {
        statusLabel.stringValue = Constants.Strings.statusText
    }

    @IBAction func changeTokenDidTouch(_ sender: Any) {
        output?.changeTokenDidTouch()
    }

    @IBAction private func addAccountDidTouch(_ sender: Any) {
        output?.addAccountDidTouch()
    }

    @IBAction func testStrategyDidTouch(_ sender: Any) {
        let id = strategiesButton.selectedItem?.identifier?.rawValue ?? .empty
        output?.testStrategyDidTouch(id: id)
    }

    @IBAction func tradingDidTouch(_ sender: Any) {
        let strategyId = strategiesButton.selectedItem?.identifier?.rawValue ?? .empty
        output?.tradingDidTouch(strategyId: strategyId)
    }

    @objc
    private func accountDidTouch(_ sender: NSMenuItem) {
        let accountModel = viewModel?.accounts.first(where: {
            return sender.identifier?.rawValue == $0.id
        })
        allMoneyLabel.stringValue = accountModel?.allMoney ?? .empty
        profitLabel.stringValue = accountModel?.profitText ?? .empty
        profitValueLabel.stringValue = accountModel?.profitValue ?? .empty
    }
}

// MARK: - TradeBotViewInput

extension TradeBotViewController: TradeBotViewInput {
    // MARK: - Func

    func set(viewModel: TradeBotViewModel) {
        self.viewModel = viewModel

        tokenTypeLabel.attributedStringValue = viewModel.tokenTypeText

//        let accountsIsEmpty: Bool = viewModel.accounts.isEmpty
//        controlView.isHidden = accountsIsEmpty
//        noAccountsView.isHidden = !accountsIsEmpty

        let menuItems: [NSMenuItem] = viewModel.accounts.map({
            let menuItem = NSMenuItem()
            menuItem.identifier = NSUserInterfaceItemIdentifier($0.id)
            menuItem.attributedTitle = NSAttributedString(
                string: $0.name,
                attributes: Constants.Attributes.accountPopUpAttributes
            )
            menuItem.target = self
            menuItem.action = #selector(accountDidTouch(_:))
            return menuItem
        })
        accountsButton.menu?.items = menuItems

        guard let firstMenuItem = accountsButton.menu?.items.first else {
            return
        }
        accountDidTouch(firstMenuItem)

        let strategiesMenuItems: [NSMenuItem] = viewModel.strategies.map({
            let menuItem = NSMenuItem()
            menuItem.identifier = NSUserInterfaceItemIdentifier($0.id)
            menuItem.attributedTitle = NSAttributedString(
                string: $0.name,
                attributes: Constants.Attributes.popUpAttributes
            )
            return menuItem
        })
        strategiesButton.menu?.items = strategiesMenuItems

        set(tradingModel: viewModel.trading)
    }

    func set(tradingModel: TradingViewModel) {
        statusValueLabel.stringValue = tradingModel.statusText
        tradingButton.setTitle(tradingModel.tradingButtonText)
    }
}
