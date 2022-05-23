//
//  GraphContentView.swift
//  TradeBot
//
//  Created by Денис Калугин on 18.05.2022.
//

import AppKit
import TinkoffInvestSDK

enum CandleMark {
    case none
    case enter
    case leave
}

struct GraphCandle: Equatable {
    let time: Date
    let open: CGFloat
    let close: CGFloat
    let low: CGFloat
    let high: CGFloat
    let mark: CandleMark
}

struct GraphContentViewModel {
    let candles: [GraphCandle]
}

final class GraphContentView: NSView {
    // MARK: - Properties

    // MARK: - Private properties

    private let graphView: GraphView = GraphView()
    private let axisXView: AxisView = AxisView()
    private let axisYView: AxisView = AxisView()
    private let cursorTableView: CursorTableView = CursorTableView()
    private var trackingArea: NSTrackingArea?
    private var viewModel: GraphContentViewModel?
    private var width: CGFloat = .zero
    private var offsetX: CGFloat = .zero
    private var minPrice: CGFloat = .zero
    private var maxPrice: CGFloat = .zero
    private var pxH: CGFloat = .zero
    private var mouseLocation: CGPoint?

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let scrollSpeed: CGFloat = 20
            static let spacing: CGFloat = 12
            static let candleWidth: CGFloat = 24
            static let minCandleH: CGFloat = 10
            static let lineW: CGFloat = 2
            static let half: CGFloat = 2
            static let hundredPercent: CGFloat = 100
            static let tenPercent: CGFloat = 10
            static let candleWidthWithSpacing = candleWidth + spacing
            static let axisLine: CGFloat = 1

            static let axisX: CGFloat = 35
            static let axisY: CGFloat = 60

            static let linesYSpace: CGFloat = 50

            static let triangleH: CGFloat = 10
            static let markSpacing: CGFloat = 8
        }
        enum Strings {
            static let dayAndMonth: String = "dd.MM"
        }
    }

    // MARK: - Func

    override init(frame frameRect: NSRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layout() {
        super.layout()

        updateTrackingAreas()

        graphView.frame = NSRect(
            x: .zero,
            y: Constants.Numbers.axisX,
            width: frame.width - Constants.Numbers.axisY,
            height: frame.height - Constants.Numbers.axisX
        )
        axisXView.frame = NSRect(
            x: .zero,
            y: .zero,
            width: frame.width,
            height: Constants.Numbers.axisX
        )
        axisYView.frame = NSRect(
            x: frame.width - Constants.Numbers.axisY,
            y: Constants.Numbers.axisX,
            width: Constants.Numbers.axisY,
            height: frame.height - Constants.Numbers.axisX
        )
        reload()
    }

    override func scrollWheel(with event: NSEvent) {
        offsetX -= event.deltaX * Constants.Numbers.scrollSpeed
        offsetX = max(.zero, min(width - graphView.frame.width, offsetX))
        reload()
        reloadCursor()
    }

    override func mouseMoved(with event: NSEvent) {
        var mouseLocation = convert(event.locationInWindow, from: superview?.superview?.superview)
        mouseLocation.y -= axisXView.frame.height
        self.mouseLocation = mouseLocation
        reloadCursor()
    }

    override func mouseExited(with event: NSEvent) {
        graphView.set(cursorViewModel: nil)
        axisXView.set(mouseValue: nil)
        axisYView.set(mouseValue: nil)
        mouseLocation = nil
        cursorTableView.isHidden = true
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()

        if let trackingAreaForRemove = trackingArea {
            removeTrackingArea(trackingAreaForRemove)
        }
        let trackingArea: NSTrackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeInActiveApp, .mouseMoved, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
        self.trackingArea = trackingArea
    }

    func set(viewModel: GraphContentViewModel) {
        self.viewModel = viewModel

        let candlesCount = CGFloat(viewModel.candles.count)
        width = candlesCount * Constants.Numbers.candleWidthWithSpacing + Constants.Numbers.spacing
        offsetX = width - graphView.frame.width

        reload()
    }

    func select(trade: TBTrade) {

    }

    // MARK: - Private func

    private func setup() {
        wantsLayer = true
        layer?.backgroundColor = Color.graphBackground.cgColor

        cursorTableView.isHidden = true

        addSubview(graphView)
        addSubview(axisXView)
        addSubview(axisYView)
        addSubview(cursorTableView)

        cursorTableView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: NSEdgeInsets(
                top: Constants.Numbers.spacing,
                left: Constants.Numbers.spacing,
                bottom: .zero,
                right: .zero
            )
        )
    }

    private func reload() {
        guard let allCandles = viewModel?.candles else {
            return
        }
        var candlesData: [CandleGraphDataModel] = []
        var axisXValues: [AxisValue] = []
        var axisYValues: [AxisValue] = []
        var linesX: [CGFloat] = []
        var linesY: [CGFloat] = []

        let startCandleIndex = max(Int(offsetX / Constants.Numbers.candleWidthWithSpacing), .zero)
        let endCandleIndex = min(Int((offsetX + graphView.frame.width) / Constants.Numbers.candleWidthWithSpacing), allCandles.count - 1)
        guard startCandleIndex < endCandleIndex else {
            return
        }
        let candles = allCandles[startCandleIndex ... endCandleIndex]

        minPrice = candles.min(by: {
            return $0.low <= $1.low
        })?.low ?? 0
        maxPrice = candles.max(by: {
            return $0.high <= $1.high
        })?.high ?? 0
        let priceDifference: CGFloat = maxPrice - minPrice
        let tenPercent: CGFloat = priceDifference * Constants.Numbers.tenPercent / Constants.Numbers.hundredPercent
        // минус 10 процентов (чтобы было посвободней снизу)
        minPrice -= tenPercent
        // плюс 10 процентов (чтобы было посвободней сверху)
        maxPrice += tenPercent

        // Сколько пикселей для одного шага цены
        pxH = graphView.frame.height / (maxPrice - minPrice)

        let linesYCount: Int = Int(graphView.frame.height / Constants.Numbers.linesYSpace)
        let yStep: CGFloat = (maxPrice - minPrice) / CGFloat(linesYCount)

        for i in 1 ... linesYCount - 1 {
            let price: CGFloat = (CGFloat(i) * yStep + minPrice).round(digits: .oneDigits)
            let position: CGFloat = (price - minPrice) * pxH

            let value: AxisValue = AxisValue(
                position: position,
                text: "\(price)"
            )
            axisYValues.append(value)
            linesY.append(position)
        }

        for (index, candle) in candles.enumerated() {
            let isGreenCandle = candle.open < candle.close
            let fillColor = isGreenCandle ? Color.greenCandle.cgColor : Color.redCandle.cgColor

            let minCandle: CGFloat = CGFloat.minimum(candle.open, candle.close)
            let maxCandle: CGFloat = CGFloat.maximum(candle.open, candle.close)

            let rect = CGRect(
                x: CGFloat(startCandleIndex + index) * Constants.Numbers.candleWidthWithSpacing - offsetX + Constants.Numbers.spacing,
                y: (minCandle - minPrice) * pxH,
                width: Constants.Numbers.candleWidth,
                height: max((maxCandle - minCandle) * pxH, Constants.Numbers.minCandleH)
            )

            let lineRect: CGRect = CGRect(
                x: rect.midX - Constants.Numbers.lineW / Constants.Numbers.half,
                y: (candle.low - minPrice) * pxH,
                width: Constants.Numbers.lineW,
                height: (candle.high - candle.low) * pxH
            )

            let markRect: CGRect = CGRect(
                x: rect.minX,
                y: max(rect.maxY, lineRect.maxY) + Constants.Numbers.markSpacing,
                width: rect.width,
                height: rect.width
            )
            let mark: CGImage?
            switch candle.mark {
            case .none:
                mark = nil
            case .enter:
                let image: NSImage = NSImage(named: "enter-in-candle")!
                var imageRect: CGRect = CGRect(
                    x: .zero,
                    y: .zero,
                    width: image.size.width,
                    height: image.size.height
                )
                mark = image.cgImage(
                    forProposedRect: &imageRect,
                    context: nil,
                    hints: nil
                )
            case .leave:
                let image: NSImage = NSImage(named: "leave-from-candle")!
                var imageRect: CGRect = CGRect(
                    x: .zero,
                    y: .zero,
                    width: image.size.width,
                    height: image.size.height
                )
                mark = image.cgImage(
                    forProposedRect: &imageRect,
                    context: nil,
                    hints: nil
                )
            }

            let candleData = CandleGraphDataModel(
                rect: rect,
                line: lineRect,
                color: fillColor,
                mark: mark,
                markRect: markRect
            )
            candlesData.append(candleData)

            let dateString: String = candle.time.string(dateFormat: Constants.Strings.dayAndMonth)
            let value: AxisValue = AxisValue(
                position: rect.midX,
                text: dateString
            )
            axisXValues.append(value)
            linesX.append(value.position)
        }

        let axisXViewModel = AxisViewModel(
            values: axisXValues,
            type: .x
        )
        axisXView.set(viewModel: axisXViewModel)

        let axisYViewModel = AxisViewModel(
            values: axisYValues,
            type: .y
        )
        axisYView.set(viewModel: axisYViewModel)

        let graphViewModel = GraphViewModel(
            candles: candlesData,
            linesX: linesX,
            linesY: linesY
        )
        graphView.set(viewModel: graphViewModel)
    }

    private func reloadCursor() {
        guard let mouseLocation = mouseLocation else {
            return
        }

        if let candle = getCandle(x: offsetX + mouseLocation.x) {
            let tableViewModel = CursorTableViewModel(
                open: candle.open.format(digits: .twoDigits),
                close: candle.close.format(digits: .twoDigits),
                low: candle.low.format(digits: .twoDigits),
                high: candle.high.format(digits: .twoDigits),
                isGreen: candle.open < candle.close
            )
            cursorTableView.set(viewModel: tableViewModel)
            cursorTableView.isHidden = false

            let cursorViewModel = GraphCursorViewModel(
                mouseLocation: mouseLocation,
                selectedCandle: getSelectedCandle(candle: candle)
            )
            graphView.set(cursorViewModel: cursorViewModel)

            let dateText = candle.time.string(dateFormat: "dd MMM yyyy")
            let axisXValue = AxisValue(
                position: mouseLocation.x,
                text: dateText
            )
            axisXView.set(mouseValue: axisXValue)
        } else {
            axisXView.set(mouseValue: nil)
        }

        let price = (mouseLocation.y / pxH + minPrice).round(digits: .oneDigits)
        let axisYValue = AxisValue(
            position: mouseLocation.y,
            text: "\(price)"
        )
        axisYView.set(mouseValue: axisYValue)
    }

    private func getCandle(x: CGFloat) -> GraphCandle? {
        guard let candles = viewModel?.candles else {
            return nil
        }
        let halfSpacing: CGFloat = Constants.Numbers.spacing / Constants.Numbers.half
        let xWithoutHalfSpacing = x - halfSpacing
        let index: Int = Int(xWithoutHalfSpacing / Constants.Numbers.candleWidthWithSpacing)
        return candles[safe: index]
    }

    private func getSelectedCandle(candle: GraphCandle) -> CandleGraphDataModel {
        let rect = getCandleRect(candle: candle)
        let lineRect = CGRect(
            x: rect.midX - Constants.Numbers.lineW.half,
            y: getYFrom(price: candle.low),
            width: Constants.Numbers.lineW,
            height: (candle.high - candle.low) * pxH
        )

        let isGreenCandle = candle.open < candle.close
        let color: CGColor = isGreenCandle ? Color.selectedGreenCandle.cgColor : Color.selectedRedCandle.cgColor

        let markRect: CGRect = CGRect(
            x: rect.minX,
            y: max(rect.maxY, lineRect.maxY) + Constants.Numbers.markSpacing,
            width: rect.width,
            height: rect.width
        )

        let mark: CGImage?
        switch candle.mark {
        case .none:
            mark = nil
        case .enter:
            let image: NSImage = NSImage(named: "enter-in-candle")!
            var imageRect: CGRect = CGRect(
                x: .zero,
                y: .zero,
                width: image.size.width,
                height: image.size.height
            )
            mark = image.cgImage(
                forProposedRect: &imageRect,
                context: nil,
                hints: nil
            )
        case .leave:
            let image: NSImage = NSImage(named: "leave-from-candle")!
            var imageRect: CGRect = CGRect(
                x: .zero,
                y: .zero,
                width: image.size.width,
                height: image.size.height
            )
            mark = image.cgImage(
                forProposedRect: &imageRect,
                context: nil,
                hints: nil
            )
        }

        let result: CandleGraphDataModel = CandleGraphDataModel(
            rect: rect,
            line: lineRect,
            color: color,
            mark: mark,
            markRect: markRect
        )
        return result
    }

    private func getCandleRect(candle: GraphCandle) -> CGRect {
        guard let candles = viewModel?.candles else {
            return .zero
        }
        let index: Int = candles.firstIndex(of: candle) ?? .zero
        let minCandle: CGFloat = CGFloat.minimum(candle.open, candle.close)
        let maxCandle: CGFloat = CGFloat.maximum(candle.open, candle.close)

        let result: CGRect = CGRect(
            x: getXFrom(index: index),
            y: getYFrom(price: minCandle),
            width: Constants.Numbers.candleWidth,
            height: max((maxCandle - minCandle) * pxH, Constants.Numbers.minCandleH)
        )
        return result
    }

    private func getXFrom(index: Int) -> CGFloat {
        let result = Constants.Numbers.spacing + index.cgFloat * Constants.Numbers.candleWidthWithSpacing - offsetX
        return result
    }

    private func getYFrom(price: CGFloat) -> CGFloat {
        let result = (price - minPrice) * pxH
        return result
    }
}
