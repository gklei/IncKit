


//
//  UINavigationBar+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 6/28/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

public extension UINavigationBar {
	public func makeTransparent() {
		setBackgroundImage(UIImage(), for: .default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, for: .default)
	}
	
	public func removeShadow() {
		shadowImage = UIImage()
	}
	
	public func resetShadow() {
		shadowImage = nil
	}
   
   public func updateShadow(with color: UIColor) {
      shadowImage = UIImage.with(color: color)
   }
}

public extension UIToolbar {
	public func makeTransparent() {
		setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
	}
	
	public func resetTransparency() {
		setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
	}
	
	public func makeShadowTransparent() {
		setShadowImage(UIImage(), forToolbarPosition: .any)
	}
}

public extension UINavigationController {
	override public func makeNavBarTransparent() {
		navigationBar.makeTransparent()
	}
	
	override public func resetNavBarTransparency() {
		navigationBar.resetTransparency()
	}
	
   override public func removeNavBarShadow() {
		navigationBar.removeShadow()
	}
	
	public override func resetNavBarShadow() {
		navigationBar.resetShadow()
	}
   
   public override func updateNavBarShadow(with color: UIColor) {
      navigationBar.updateShadow(with: color)
   }
}
