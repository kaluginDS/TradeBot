//
//  Label.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import AppKit

final class Label: NSTextField {
    // MARK: - Properties

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Private func

    private func setup() {
        isEditable = false
        isBordered = false
        drawsBackground = true
        backgroundColor = .clear
        font = NSFont.systemFont(ofSize: 14, weight: .semibold)
        textColor = Color.blueText
    }
}
