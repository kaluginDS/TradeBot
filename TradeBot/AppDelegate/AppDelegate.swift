//
//  AppDelegate.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Properties
    
    var window: NSWindow!

    // MARK: - Constants

    private enum Constants {
        enum Numbers {
            static let defaultWidth: CGFloat = 600
            static let defaultHeight: CGFloat = 300
            static let divider: CGFloat = 3 / 4
        }
        enum Strings {
            static let paste: String = "Paste"
            static let quite: String = "Quite"
            static let pasteKey: String = "v"
            static let quiteKey: String = "q"
        }
    }

    // MARK: - Func

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.title = "TradeBot"

        let model = MainModuleModel()
        let module = MainModule(model: model)
        window.contentViewController = module.view

        window.makeKeyAndOrderFront(nil)

        let width: CGFloat = NSScreen.main?.frame.width ?? Constants.Numbers.defaultWidth
        let height: CGFloat = NSScreen.main?.frame.height ?? Constants.Numbers.defaultHeight

        let windowFrame: NSRect = NSRect(
            x: .zero,
            y: .zero,
            width: width * Constants.Numbers.divider,
            height: height * Constants.Numbers.divider
        )

        window.setFrame(windowFrame, display: false)
        window.center()

        let mainMenu = NSMenu()
        NSApp.mainMenu = mainMenu

        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)

        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        appMenu.addItem(
            withTitle: Constants.Strings.paste,
            action: #selector(pasteText),
            keyEquivalent: Constants.Strings.pasteKey
        )
        appMenu.addItem(
            withTitle: Constants.Strings.quite,
            action:#selector(NSApplication.terminate),
            keyEquivalent: Constants.Strings.quiteKey
        )
    }

    @objc
    func pasteText() {
        let copiedText = NSPasteboard.general.string(forType: .string)
        if let field = window.firstResponder as? NSTextView,
           let text = copiedText, !text.isEmpty {

            field.string = text
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

