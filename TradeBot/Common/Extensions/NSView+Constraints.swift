//
//  UIView+Constraints.swift
//  TradeBot
//
//  Created by Денис Калугин on 16.05.2022.
//

import AppKit

extension NSView {

    func setView(_ view: NSView, padding: NSEdgeInsets = NSEdgeInsets.zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.fillSuperview(padding: padding)
    }

    func fillSuperview(padding: NSEdgeInsets = NSEdgeInsets.zero) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }

    func setToCenter(_ view: NSView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    func anchorSize(to view: NSView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    func anchorWidth(to view: NSView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }

    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: NSEdgeInsets = .zero,
        size: CGSize = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension NSEdgeInsets {
    static var zero: NSEdgeInsets { return NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
}

