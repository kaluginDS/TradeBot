//
//  ChildModule.swift
//  TradeBot
//
//  Created by Денис Калугин on 17.05.2022.
//

import Cocoa

protocol ChildModule {
    var presentableView: Presentable! { get set }

    func showInContainer(container: NSView, in vc: NSViewController)
}

extension ChildModule {
    
    func showInContainer(container: NSView, in vc: NSViewController) {
        presentableView.showInContainer(container: container, in: vc)
    }
}
