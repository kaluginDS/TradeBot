//
//  Presentable.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import Foundation
import Cocoa

protocol Presentable {

    var viewController: NSViewController { get }

    func showInContainer(container: NSView, in vc: NSViewController)
}

extension Presentable where Self: NSViewController {

    var viewController: NSViewController {
        return self
    }

    func showInContainer(container: NSView, in vc: NSViewController) {
        container.setView(view)
        vc.addChild(self)
    }
}
