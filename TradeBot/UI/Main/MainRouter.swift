//
//  MainRouter.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import Cocoa

enum ContainerModuleType {
    case tradeBot
    case graph
}

final class MainRouter {
    // MARK: - Properties

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - MainRouterInput

extension MainRouter: MainRouterInput {
    // MARK: - Func

    func addGraphModule(
        container: NSView,
        in vc: NSViewController,
        model: GraphModuleModel
    ) -> GraphModule? {
        let module: ChildModule = GraphModule(model: model)
        module.showInContainer(container: container, in: vc)
        return module as? GraphModule
    }

    func addTradeBotModule(
        container: NSView,
        in vc: NSViewController,
        model: TradeBotModuleModel
    ) {
        let module: ChildModule = TradeBotModule(model: model)
        module.showInContainer(container: container, in: vc)
    }

    func addTesterModule(
        container: NSView,
        in vc: NSViewController,
        model: TesterModuleModel
    ) -> TesterModule? {
        let module: ChildModule = TesterModule(model: model)
        module.showInContainer(container: container, in: vc)
        return module as? TesterModule
    }
}
