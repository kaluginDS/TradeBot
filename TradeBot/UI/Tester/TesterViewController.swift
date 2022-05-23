//
//  TesterViewController.swift
//  TradeBot
//
//  Created by Денис Калугин on 19.05.2022.
//

import Cocoa

struct TradeRowViewModel {
    let type: TwoLabelCellViewModel
    let tradeType: LabelCellViewModel
    let dates: TwoLabelCellViewModel
    let prices: TwoLabelCellViewModel
    let profit: LabelCellViewModel
}

struct TesterViewControllerModel {
    let rows: [TradeRowViewModel]
}

final class TesterViewController: NSViewController, ViewControllerable {
    // MARK: - Properties

    var output: TesterViewOutput!

    // MARK: - Private properties

    @IBOutlet weak var tableView: NSTableView!

    private var viewModel: TesterViewControllerModel = TesterViewControllerModel(rows: [])

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let rowCornerRadius: CGFloat = 8
            static let cellSpacing: CGFloat = 16
            static let evenDivider: Int = 2
            static let intercellSpacing: NSSize = NSSize(
                width: 24,
                height: .zero
            )
        }
        enum Attributes {
            static var paragraph: NSParagraphStyle {
                let result: NSMutableParagraphStyle = NSMutableParagraphStyle()
                result.alignment = .center
                return result
            }
            static let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: Color.grayText,
                .paragraphStyle: paragraph
            ]
        }
    }

    private enum ColumnType: String, CaseIterable {
        case type = "СДЕЛКА"
        case tradeType = "ТИП СДЕЛКИ"
        case date = "ДАТА"
        case price = "ЦЕНА"
        case profit = "ПРИБЫЛЬ"
    }

    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = Color.whiteBackground.cgColor

        setupTableView()

        output.viewIsReady()
    }

    // MARK: - Private func

    private func setupTableView() {
        tableView.allowsColumnSelection = false
        tableView.allowsColumnReordering = false
        tableView.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        tableView.style = .plain
        tableView.backgroundColor = .clear
        tableView.gridColor = NSColor.red
        tableView.enclosingScrollView?.backgroundColor = .clear
        tableView.intercellSpacing = NSSize(
            width: 24,
            height: Constants.Numbers.cellSpacing
        )

        tableView.delegate = self
        tableView.dataSource = self

        ColumnType.allCases.forEach({
            let column = NSTableColumn()
            column.identifier = NSUserInterfaceItemIdentifier($0.rawValue)
//            column.title = $0.rawValue
//            column.headerCell.alignment = .center
//            column.headerCell
            column.headerCell.attributedStringValue = NSAttributedString(
                string: $0.rawValue,
                attributes: Constants.Attributes.headerAttributes
            )
            column.headerCell.backgroundColor = NSColor.clear
            column.resizingMask = .autoresizingMask
            tableView.addTableColumn(column)
        })
    }
}

// MARK: - TesterViewInput

extension TesterViewController: TesterViewInput {
    // MARK: Func

    func set(viewModel: TesterViewControllerModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - NSTableViewDelegate, NSTableViewDataSource

extension TesterViewController: NSTableViewDelegate, NSTableViewDataSource {
    // MARK: Func

    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModel.rows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier.rawValue,
              let id = ColumnType(rawValue: identifier),
              let row = viewModel.rows[safe: row] else {
            return nil
        }
        switch id {
        case .type:
            let cell = TwoLabelCellView()
            cell.set(viewModel: row.type)
            return cell
        case .tradeType:
            let cell = LabelCellView()
            cell.set(viewModel: row.tradeType)
            return cell
        case .date:
            let cell = TwoLabelCellView()
            cell.set(viewModel: row.dates)
            return cell
        case .price:
            let cell = TwoLabelCellView()
            cell.set(viewModel: row.prices)
            return cell
        case .profit:
            let cell = LabelCellView()
            cell.set(viewModel: row.profit)
            return cell
        }
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView: NSTableRowView = NSTableRowView()
        let isEven: Bool = row % Constants.Numbers.evenDivider == .zero
        rowView.wantsLayer = true
        rowView.layer?.backgroundColor = isEven ? Color.whiteBackground.cgColor : Color.axisLine.cgColor
        rowView.layer?.cornerRadius = Constants.Numbers.rowCornerRadius
        return rowView
    }
}
