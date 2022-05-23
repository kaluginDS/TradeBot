//
//  AxisView.swift
//  TradeBot
//
//  Created by Денис Калугин on 18.05.2022.
//

import AppKit

struct AxisValue {
    var position: CGFloat
    var text: String
}

enum AxisType {
    case x
    case y
}

struct AxisViewModel {
    let values: [AxisValue]
    let type: AxisType
}

final class AxisView: NSView {
    // MARK: - Properties

    // MARK: - Private properties

    private var viewModel: AxisViewModel?
    private var mouseValue: AxisValue?

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let half: CGFloat = 2
            static let labelInset: CGFloat = 5
        }
        enum Attributes {
            static let axisAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: Color.graphAxisText
            ]
            static let mouseAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: Color.whiteText
            ]
        }
    }

    // MARK: - Func

    override func draw(_ dirtyRect: NSRect) {
        guard let viewModel = viewModel else {
            return
        }
        let type: AxisType = viewModel.type

        for value in viewModel.values {
            let text = NSAttributedString(
                string: value.text,
                attributes: Constants.Attributes.axisAttributes
            )
            let textSize: NSSize = text.size()
            let side: CGFloat = type == .x ? textSize.width : textSize.height
            let centerPosition: CGFloat = value.position - side / Constants.Numbers.half
            let x: CGFloat = frame.width / Constants.Numbers.half - textSize.width / Constants.Numbers.half
            let y: CGFloat = frame.height / Constants.Numbers.half - textSize.height / Constants.Numbers.half
            let rect = NSRect(
                x: type == .x ? centerPosition : x,
                y: type == .y ? centerPosition : y,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: rect)
        }

        guard let mouseValue = mouseValue,
              let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }

        let text = NSAttributedString(
            string: mouseValue.text,
            attributes: Constants.Attributes.mouseAttributes
        )
        let textSize: CGSize = text.size()

        ctx.setFillColor(Color.cursorLine.cgColor)

        let halfTextWidth: CGFloat = textSize.width / Constants.Numbers.half
        let halfTextHeight: CGFloat = textSize.height / Constants.Numbers.half
        let oneInset: CGFloat = Constants.Numbers.labelInset / Constants.Numbers.half
        let labelRect = CGRect(
            x: type == .x ? mouseValue.position - halfTextWidth - oneInset : .zero,
            y: type == .y ? mouseValue.position - halfTextHeight - oneInset : .zero,
            width: type == .y ? frame.width : textSize.width + Constants.Numbers.labelInset,
            height: type == .x ? frame.height : textSize.height + Constants.Numbers.labelInset
        )
        ctx.fill(labelRect)

        let side: CGFloat = type == .x ? textSize.width : textSize.height
        let centerPosition: CGFloat = mouseValue.position - side / Constants.Numbers.half
        let x: CGFloat = frame.width / Constants.Numbers.half - textSize.width / Constants.Numbers.half
        let y: CGFloat = frame.height / Constants.Numbers.half - textSize.height / Constants.Numbers.half
        let textRect: CGRect = CGRect(
            x: type == .x ? centerPosition : x,
            y: type == .y ? centerPosition : y,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect)
    }

    func set(viewModel: AxisViewModel) {
        self.viewModel = viewModel
        setNeedsDisplay(bounds)
    }

    func set(mouseValue: AxisValue?) {
        self.mouseValue = mouseValue
        setNeedsDisplay(bounds)
    }

    // MARK: - Private func
}
