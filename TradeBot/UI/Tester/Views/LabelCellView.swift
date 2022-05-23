//
//  LabelCellView.swift
//  TradeBot
//
//  Created by Денис Калугин on 20.05.2022.
//

import AppKit

struct LabelCellViewModel {
    let text: NSAttributedString
}

final class LabelCellView: NSTableCellView {
    // MARK: - Properties

    // MARK: - Private properties

    private let label = Label()

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

    func set(viewModel: LabelCellViewModel) {
        label.attributedStringValue = viewModel.text
    }

    // MARK: - Private func

    private func setup() {
        label.alignment = .center
        setToCenter(label)
    }
}

