//
//  GraphViewController.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import Cocoa

final class GraphViewController: NSViewController, ViewControllerable {
    // MARK: - Properties

    var output: GraphViewOutput!

    // MARK: - Private properties

    @IBOutlet weak var graphContentView: GraphContentView!
//    private let graphLayer: GraphLayer = GraphLayer()

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.wantsLayer = true
//        view.layer?.backgroundColor = NSColor.red.cgColor

//        view.layer = graphLayer
//        view.layer?.addSublayer(graphLayer)

        output.viewIsReady()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

//        graphLayer.frame = view.bounds
//        graphLayer.setNeedsDisplay()
    }

    // MARK: - Private func
}

// MARK: - GraphViewInput

extension  GraphViewController: GraphViewInput {
    // Func

    func set(viewModel: GraphContentViewModel) {
//        graphLayer.set(viewModel: viewModel)
        graphContentView.set(viewModel: viewModel)
    }
}
