//
//  MainViewController.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import Cocoa

struct TokenViewModel {
    let appName: String
    let token: String
    let tokenTypeText: String
    let tokenTypes: [String]
    let segmentIndex: Int
    let inputTokenText: String
    let inputTokenPlaceholder: String
    let doneButtonText: String
}

final class MainViewController: NSViewController, ViewControllerable {
    // MARK: - Properties

    var output: MainViewOutput!
    @IBOutlet weak var tradeBotView: NSView!
    @IBOutlet weak var graphView: NSView!
    @IBOutlet weak var testerView: NSView!

    // MARK: - Private properties

    @IBOutlet private weak var appView: NSView!
    @IBOutlet private weak var tokenView: NSView!
    @IBOutlet private weak var appNameLabel: NSTextField!
    @IBOutlet private weak var inputTokenLabel: NSTextField!
    @IBOutlet private weak var inputTextField: NSTextField!
    @IBOutlet private weak var tokenTypeLabel: NSTextField!
    @IBOutlet private weak var tokenTypeSegment: NSSegmentedControl!
    @IBOutlet private weak var doneButton: NSButton!

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let appNameFontSize: CGFloat = 24
            static let segmentWidth: CGFloat = 70
            static let testerWidth: CGFloat = 440
        }
    }

    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()

        appView.isHidden = true
        tokenView.isHidden = true
        appNameLabel.font = NSFont.systemFont(ofSize: Constants.Numbers.appNameFontSize)

        tokenTypeSegment.target = self
        tokenTypeSegment.action = #selector(selectTokenType(_:))

        output.viewIsReady()
    }

    // MARK: - Private func

    @objc
    private func selectTokenType(_ sender: NSSegmentedControl) {
        let label = tokenTypeSegment.label(forSegment: tokenTypeSegment.selectedSegment) ?? .empty
        output.selectTokenType(string: label)
    }

    @IBAction func doneButtonDidTouch(_ sender: Any) {
        output.doneButtonDidTouch(token: inputTextField.stringValue)
    }
}

// MARK: - MainViewInput

extension MainViewController: MainViewInput {
    // MARK: - Func

    func showAppView() {
        appView.isHidden = false
        tokenView.isHidden = true
    }

    func showTokenView() {
        appView.isHidden = true
        tokenView.isHidden = false
    }

    func set(tokenModel: TokenViewModel) {
        appNameLabel.stringValue = tokenModel.appName

        inputTokenLabel.stringValue = tokenModel.inputTokenText
        inputTextField.stringValue = tokenModel.token
        for (i, tokenType) in tokenModel.tokenTypes.enumerated() {
            tokenTypeSegment.setLabel(tokenType, forSegment: i)
            tokenTypeSegment.setWidth(Constants.Numbers.segmentWidth, forSegment: i)
        }
        tokenTypeSegment.selectedSegment = tokenModel.segmentIndex
        selectTokenType(tokenTypeSegment)

        inputTextField.placeholderString = tokenModel.inputTokenPlaceholder
        tokenTypeLabel.stringValue = tokenModel.tokenTypeText

        doneButton.title = tokenModel.doneButtonText
    }

    func set(token: String) {
        inputTextField.stringValue = token
    }
}
