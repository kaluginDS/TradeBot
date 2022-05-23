//
//  Alertable.swift
//  TradeBot
//
//  Created by Денис Калугин on 22.05.2022.
//

import AppKit

protocol Alertable {
    func showError(error: Error)
    func showError(message: String)
}

extension Alertable {
    // MARK: Func

    func showError(error: Error) {
        let alert = NSAlert(error: error)
//        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }

    func showError(message: String) {
        let alert = NSAlert()
        alert.messageText = message
        alert.runModal()
    }
}
