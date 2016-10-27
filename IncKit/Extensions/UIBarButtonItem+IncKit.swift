//
//  UIBarButtonItem+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/9/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
	public static func back(target: AnyObject? = nil, action: Selector? = nil) -> UIBarButtonItem {
		let overriddenTarget = action != nil ? target : nil
		let overriddenAction = action ?? #selector(UIBarButtonItem.incKit_doNothing)
		return UIBarButtonItem(title: "Back", style: .plain, target: overriddenTarget, action: overriddenAction)
	}
	
	public static var empty: UIBarButtonItem {
		return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	public func update(color: UIColor) {
		tintColor = color
		if var attributes = titleTextAttributes(for: .normal) {
			attributes[NSForegroundColorAttributeName] = color
		} else {
			setTitleTextAttributes([NSForegroundColorAttributeName : color], for: .normal)
		}
		
		let highlightedColor = color.withAlphaComponent(0.4)
		if var attributes = titleTextAttributes(for: .highlighted) {
			attributes[NSForegroundColorAttributeName] = highlightedColor
		} else {
			setTitleTextAttributes([NSForegroundColorAttributeName : highlightedColor], for: .highlighted)
		}
	}
	
	@objc private func incKit_doNothing() {}
}
