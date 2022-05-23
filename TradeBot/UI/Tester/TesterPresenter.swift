//
//  TesterPresenter.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import AppKit

final class TesterPresenter {
    // MARK: - Properties

    weak var view: TesterViewInput!
    var interactor: TesterInteractorInput!
    var router: TesterRouterInput!
    weak var output: TesterModuleOutput?

    // MARK: - Private properties

    private var strategyTester: StrategyTesterModule?

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let hundredPercent: Decimal = 100
        }
        enum Strings {
            static let enter: String = "Вход"
            static let leave: String = "Выход"
            static let long: String = "Long"
            static let short: String = "Short"
            static let percent: String = "%"
        }
        enum Attributes {
            static var paragraph: NSParagraphStyle {
                let result: NSMutableParagraphStyle = NSMutableParagraphStyle()
                result.alignment = .center
                return result
            }
            static let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: Color.darkBlueText,
                .paragraphStyle: paragraph
            ]
            static let greenAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: Color.greenCandle,
                .paragraphStyle: paragraph
            ]
            static let redAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: Color.redCandle,
                .paragraphStyle: paragraph
            ]
        }
    }

    // MARK: - Func

    func test(strategy: TradeStrategyInput) {
        view.showLoader()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.strategyTester?.testStrategy(strategy: strategy)
//        }
        strategyTester?.testStrategy(strategy: strategy)
    }

    // MARK: - Private func
}

// MARK: - TesterViewOutput

extension TesterPresenter: TesterViewOutput {

    func viewIsReady() {
        let model: StrategyTesterModuleModel = StrategyTesterModuleModel(
            figi: GlobalConstants.figi,
            output: self
        )
        let strategyTester: StrategyTesterModule = StrategyTesterModule(model: model)
        self.strategyTester = strategyTester
    }
}

// MARK: - TesterInteractorOutput

extension TesterPresenter: TesterInteractorOutput {

}

// MARK: - StrategyTesterModuleOutputModel

extension TesterPresenter: StrategyTesterModuleOutput {
    // MARK: Func

    func testCompleted(model: StrategyTesterModuleOutputModel) {
        let rows: [TradeRowViewModel] = model.trades.map({
            let type: TwoLabelCellViewModel = TwoLabelCellViewModel(
                topText: Constants.Strings.enter,
                bottomText: Constants.Strings.leave
            )

            let tradeTypeText: NSAttributedString = NSAttributedString(
                string: $0.startTrade.direction == .buy ? Constants.Strings.long : Constants.Strings.short,
                attributes: Constants.Attributes.defaultAttributes
            )
            let tradeType: LabelCellViewModel = LabelCellViewModel(text: tradeTypeText)

            let dates: TwoLabelCellViewModel = TwoLabelCellViewModel(
                topText: $0.startTrade.time.date.string(),
                bottomText: $0.endTrade?.time.date.string() ?? .empty
            )

            let lastPrice: Decimal? = $0.endTrade?.price.asAmount

            let prices: TwoLabelCellViewModel = TwoLabelCellViewModel(
                topText: "\($0.startTrade.price.asAmount)",
                bottomText: lastPrice.map({ "\($0)" }) ?? .empty
            )

            var profitText: NSAttributedString = .empty
            if let endPrice = $0.endTrade?.price.asAmount {
                let percent: Decimal = endPrice * Constants.Numbers.hundredPercent / $0.startTrade.price.asAmount
                let profit: Decimal = percent - Constants.Numbers.hundredPercent
                let isGreen: Bool = profit >= .zero
                profitText = NSAttributedString(
                    string: "\(profit.format(digits: .twoDigits)) \(Constants.Strings.percent)",
                    attributes: isGreen ? Constants.Attributes.greenAttributes : Constants.Attributes.redAttributes
                )
            }
            let profit: LabelCellViewModel = LabelCellViewModel(text: profitText)

            let result = TradeRowViewModel(
                type: type,
                tradeType: tradeType,
                dates: dates,
                prices: prices,
                profit: profit
            )
            return result
        })
        let viewModel: TesterViewControllerModel = TesterViewControllerModel(rows: rows)
        DispatchQueue.main.async {
            self.view.set(viewModel: viewModel)
            let graphViewModel: GraphContentViewModel = GraphContentViewModel(candles: model.candles)
            self.output?.testDidComplete(viewModel: graphViewModel)
            self.view.hideLoader()
        }
    }
}
