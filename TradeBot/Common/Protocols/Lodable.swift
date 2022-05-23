//
//  Lodable.swift
//  TradeBot
//
//  Created by Денис Калугин on 21.05.2022.
//

import AppKit

protocol Lodable {
    func showLoader()
    func hideLoader()
}

extension Lodable where Self: NSViewController {
    // MARK: Private property

    private var loaderContentId: String {
        return "loaderContent"
    }

    private var loaderId: String {
        return "loader"
    }

    // MARK: Func

    func showLoader() {
        let content = NSView()
        content.identifier = NSUserInterfaceItemIdentifier(rawValue: loaderContentId)
        content.wantsLayer = true
        content.layer?.backgroundColor = NSColor.white.cgColor
        content.alphaValue = 0.8

        let loader = NSProgressIndicator()
        loader.identifier = NSUserInterfaceItemIdentifier(rawValue: loaderId)
        loader.isIndeterminate = true

        view.setView(content)
        view.setToCenter(loader)
        let size: NSSize = NSSize(
            width: 100,
            height: 40
        )
        loader.anchor(size: size)
        loader.startAnimation(self)
    }

    func hideLoader() {
        view.subviews.forEach({
            if $0.identifier?.rawValue == loaderContentId ||
                $0.identifier?.rawValue == loaderId {

                $0.removeFromSuperview()
            }
        })
    }
}
