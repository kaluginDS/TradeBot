//
//  GraphView.swift
//  TradeBot
//
//  Created by Денис Калугин on 18.05.2022.
//

import AppKit

struct CandleGraphDataModel {
    let rect: NSRect
    let line: NSRect
    let color: CGColor
    let mark: CGImage?
    let markRect: CGRect?
}

struct GraphViewModel {
    let candles: [CandleGraphDataModel]
    let linesX: [CGFloat]
    let linesY: [CGFloat]
}

struct GraphCursorViewModel {
    let mouseLocation: CGPoint
    let selectedCandle: CandleGraphDataModel
}

final class GraphView: NSView {
    // MARK: - Properties

    // MARK: - Private properties

    private var viewModel: GraphViewModel = GraphViewModel(
        candles: [],
        linesX: [],
        linesY: []
    )
    private var cursorViewModel: GraphCursorViewModel?

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let half: CGFloat = 2
            static let lineWidth: CGFloat = 1
            static let cursorStrokeW: CGFloat = 1
            static let cornerRadius: CGFloat = 3
        }
    }

    // MARK: - Func

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }

        ctx.setFillColor(Color.axisLine.cgColor)

        viewModel.linesX.forEach({
            let rect = NSRect(
                x: $0 - Constants.Numbers.lineWidth / Constants.Numbers.half,
                y: .zero,
                width: Constants.Numbers.lineWidth,
                height: frame.height
            )
            ctx.fill(rect)
        })

        viewModel.linesY.forEach({
            let rect = NSRect(
                x: .zero,
                y: $0 - Constants.Numbers.lineWidth / Constants.Numbers.half,
                width: frame.width,
                height: Constants.Numbers.lineWidth
            )
            ctx.fill(rect)
        })

        viewModel.candles.forEach({
            ctx.setFillColor($0.color)

            let path: CGPath = CGPath(
                roundedRect: $0.rect,
                cornerWidth: Constants.Numbers.cornerRadius,
                cornerHeight: Constants.Numbers.cornerRadius,
                transform: nil
            )

            ctx.addPath(path)
            ctx.fillPath()

            let linePath: CGPath = CGPath(
                roundedRect: $0.line,
                cornerWidth: Constants.Numbers.cornerRadius,
                cornerHeight: Constants.Numbers.cornerRadius,
                transform: nil
            )
            ctx.addPath(linePath)
            ctx.fillPath()

            if let image = $0.mark,
               let imageRect = $0.markRect {
                ctx.draw(image, in: imageRect)
            }
        })

        guard let cursorViewModel = cursorViewModel else {
            return
        }

        let selectedCandle: CandleGraphDataModel = cursorViewModel.selectedCandle
        ctx.setFillColor(selectedCandle.color)

        let path: CGPath = CGPath(
            roundedRect: selectedCandle.rect,
            cornerWidth: Constants.Numbers.cornerRadius,
            cornerHeight: Constants.Numbers.cornerRadius,
            transform: nil
        )

        ctx.addPath(path)
        ctx.fillPath()

        let linePath: CGPath = CGPath(
            roundedRect: selectedCandle.line,
            cornerWidth: Constants.Numbers.cornerRadius,
            cornerHeight: Constants.Numbers.cornerRadius,
            transform: nil
        )
        ctx.addPath(linePath)
        ctx.fillPath()

        ctx.setFillColor(Color.cursorLine.cgColor)

        let mouseXLineRect: CGRect = CGRect(
            x: cursorViewModel.mouseLocation.x - Constants.Numbers.lineWidth / Constants.Numbers.half,
            y: .zero,
            width: Constants.Numbers.lineWidth,
            height: frame.height
        )
        ctx.fill(mouseXLineRect)

        let mouseYLineRect: CGRect = CGRect(
            x: .zero,
            y: cursorViewModel.mouseLocation.y - Constants.Numbers.lineWidth / Constants.Numbers.half,
            width: frame.width,
            height: Constants.Numbers.lineWidth
        )
        ctx.fill(mouseYLineRect)
    }

    func set(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        setNeedsDisplay(bounds)
    }

    func set(cursorViewModel: GraphCursorViewModel?) {
        self.cursorViewModel = cursorViewModel
        setNeedsDisplay(bounds)
    }

    // MARK: - Private func
}
