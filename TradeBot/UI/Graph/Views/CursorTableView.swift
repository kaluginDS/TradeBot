//
//  CursorTableView.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import AppKit

struct CursorTableViewModel {
    let open: String
    let close: String
    let low: String
    let high: String
    let isGreen: Bool
}

final class CursorTableView: NSView {
    // MARK: - Properties

    // MARK: - Private properties

    private let openLabel: Label = Label()
    private let closeLabel: Label = Label()
    private let lowLabel: Label = Label()
    private let highLabel: Label = Label()

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let spacing: CGFloat = 8
            static let cornerRadius: CGFloat = 8
        }
        enum Attributes {
            static let defaultAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: Color.grayText
            ]
            static let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 14, weight: .semibold),
                .foregroundColor: Color.blueText
            ]
        }
        enum Strings {
            static let open: String = "Откр"
            static let close: String = "Закр"
            static let low: String = "Мин"
            static let high: String = "Макс"
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

    func set(viewModel: CursorTableViewModel) {
        openLabel.attributedStringValue = NSAttributedString(
            string: viewModel.open,
            attributes: Constants.Attributes.valueAttributes
        )
        closeLabel.attributedStringValue = NSAttributedString(
            string: viewModel.close,
            attributes: Constants.Attributes.valueAttributes
        )
        lowLabel.attributedStringValue = NSAttributedString(
            string: viewModel.low,
            attributes: Constants.Attributes.valueAttributes
        )
        highLabel.attributedStringValue = NSAttributedString(
            string: viewModel.high,
            attributes: Constants.Attributes.valueAttributes
        )
    }

    // MARK: - Private func

    private func setup() {
        wantsLayer = true
        layer?.cornerRadius = Constants.Numbers.cornerRadius
        layer?.backgroundColor = Color.whiteBackground.cgColor

        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = Constants.Numbers.spacing

        let openText: NSAttributedString = NSAttributedString(
            string: Constants.Strings.open,
            attributes: Constants.Attributes.defaultAttributes
        )
        let openStack = getTwoLabelStack(
            text: openText,
            rightLabel: openLabel
        )

        let closeText: NSAttributedString = NSAttributedString(
            string: Constants.Strings.close,
            attributes: Constants.Attributes.defaultAttributes
        )
        let closeStack = getTwoLabelStack(
            text: closeText,
            rightLabel: closeLabel
        )

        let lowText: NSAttributedString = NSAttributedString(
            string: Constants.Strings.low,
            attributes: Constants.Attributes.defaultAttributes
        )
        let lowStack = getTwoLabelStack(
            text: lowText,
            rightLabel: lowLabel
        )

        let highText: NSAttributedString = NSAttributedString(
            string: Constants.Strings.high,
            attributes: Constants.Attributes.defaultAttributes
        )
        let highStack = getTwoLabelStack(
            text: highText,
            rightLabel: highLabel
        )

        stackView.addArrangedSubview(openStack)
        stackView.addArrangedSubview(closeStack)
        stackView.addArrangedSubview(lowStack)
        stackView.addArrangedSubview(highStack)

        setView(
            stackView,
            padding: NSEdgeInsets(
                top: Constants.Numbers.spacing,
                left: Constants.Numbers.spacing,
                bottom: Constants.Numbers.spacing,
                right: Constants.Numbers.spacing
            )
        )
    }

    private func getTwoLabelStack(text: NSAttributedString, rightLabel: NSTextField) -> NSStackView {
        let leftLabel = Label()
        leftLabel.isEditable = false
        leftLabel.isBordered = false
        leftLabel.alignment = .left
        leftLabel.attributedStringValue = text

        rightLabel.alignment = .right

        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.spacing = Constants.Numbers.spacing
        stackView.distribution = .fill

        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightLabel)
        return stackView
    }
}
