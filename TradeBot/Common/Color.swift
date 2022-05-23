//
//  Color.swift
//  TradeBot
//
//  Created by Денис Калугин on 22.05.2022.
//

import Foundation
import AppKit

enum Color {
    static let background: NSColor = NSColor(hex: "#F2F6FF")
    static let whiteBackground: NSColor = NSColor(hex: "#FFFFFF")
    static let buttonBackground: NSColor = NSColor(hex: "#5B51DE")

    static let grayText: NSColor = NSColor(hex: "#94979E")
    static let blueText: NSColor = NSColor(hex: "#2E3A59")
    static let darkBlueText: NSColor = NSColor(hex: "#001A34")
    static let whiteText: NSColor = NSColor(hex: "#FFFFFF")
    static let graphAxisText: NSColor = NSColor(hex: "#A9ACB4")

    static let graphBackground: NSColor = NSColor(hex: "#F9FCFF")
    static let greenCandle: NSColor = NSColor(hex: "#10C44C")
    static let redCandle: NSColor = NSColor(hex: "#F53C14")
    static let selectedGreenCandle: NSColor = NSColor(hex: "#0CA53F")
    static let selectedRedCandle: NSColor = NSColor(hex: "#CF3311")
    static let cursorLine: NSColor = NSColor(hex: "#001A34")
    static let axisLine: NSColor = NSColor(hex: "#F2F5F9")
}
