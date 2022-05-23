//
//  ViewControllerable.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import Cocoa

protocol ViewControllerable: AnyObject {
    
}

extension ViewControllerable where Self: NSViewController {

    static func create() -> Self {
        let className = NSStringFromClass(Self.self)
        let finalClassName = className.components(separatedBy: ".").last ?? ""
        let storyboard = NSStoryboard(name: finalClassName, bundle: nil)

        let identifier = NSStoryboard.SceneIdentifier(finalClassName)
        let viewController = storyboard.instantiateController(
            identifier: identifier,
            creator: { coder in
                Self.init(coder: coder)
            }
        )
        return viewController
    }
}
