//
//  main.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
