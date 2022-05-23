//
//  Button.swift
//  TradeBot
//
//  Created by Денис Калугин on 23.05.2022.
//

import AppKit

final class Button: NSButton {
    // MARK: - Properties

    // MARK: - Private properties

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let cornerRadius: CGFloat = 8
        }
        enum Attributes {
            static let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: Color.whiteText
            ]
        }
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

    func setTitle(_ title: String) {
        attributedTitle = NSAttributedString(
            string: title,
            attributes: Constants.Attributes.defaultAttributes
        )
    }

    // MARK: - Private func

    private func setup() {
        isBordered = false
        wantsLayer = true
        layer?.backgroundColor = Color.buttonBackground.cgColor
        layer?.cornerRadius = Constants.Numbers.cornerRadius
    }
}
