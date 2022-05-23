//
//  TwoLabelCellView.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import AppKit

struct TwoLabelCellViewModel {
    let topText: String
    let bottomText: String
}

final class TwoLabelCellView: NSTableCellView {
    // MARK: - Properties

    // MARK: - Private properties

    private let topLabel = Label()
    private let bottomLabel = Label()

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

    func set(viewModel: TwoLabelCellViewModel) {
        topLabel.stringValue = viewModel.topText
        bottomLabel.stringValue = viewModel.bottomText
    }

    // MARK: - Private func

    private func setup() {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8

        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(bottomLabel)

        setView(stackView)
    }
}
