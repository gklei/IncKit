//
//  UIView+Extensions.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/20/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

public extension UIView {
	public func addAndFill(subview subview: UIView) {
		addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
		subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	
	public func addBorder(withSize size: CGFloat, toEdge edge: UIRectEdge, padding: CGFloat = 0.0) -> UIView? {
		switch edge {
		case UIRectEdge.top: return _addTopBorder(withSize: size, padding: padding)
		case UIRectEdge.left: return _addLeftBorder(withSize: size, padding: padding)
		case UIRectEdge.bottom: return _addBottomBorder(withSize: size, padding: padding)
		case UIRectEdge.right: return _addRightBorder(withSize: size, padding: padding)
		default: return nil
		}
	}
	
	public func addBorders(withSize size: CGFloat, toEdges edges: UIRectEdge, padding: CGFloat = 0.0) -> [UIView] {
		var borders: [UIView] = []
		
		if edges.contains(.top) {
			borders.append(_addTopBorder(withSize: size, padding: padding))
		}
		if edges.contains(.left) {
			borders.append(_addLeftBorder(withSize: size, padding: padding))
		}
		if edges.contains(.bottom) {
			borders.append(_addBottomBorder(withSize: size, padding: padding))
		}
		if edges.contains(.right) {
			borders.append(_addRightBorder(withSize: size, padding: padding))
		}
		
		return borders
	}
	
	public func addBordersToAllEdges(borderSize size: CGFloat) -> [UIView] {
		return addBorders(withSize: size, toEdges: [.top, .right, .bottom, .left])
	}
	
	private func _addTopBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.topAnchor.constraint(equalTo: topAnchor).isActive = true
		border.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
		border.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
		border.heightAnchor.constraint(equalToConstant: size).isActive = true
		
		return border
	}
	
	private func _addBottomBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		border.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
		border.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
		border.heightAnchor.constraint(equalToConstant: size).isActive = true
		
		return border
	}
	
	private func _addLeftBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		border.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
		border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
		border.widthAnchor.constraint(equalToConstant: size).isActive = true
		
		return border
	}
	
	private func _addRightBorder(withSize size: CGFloat, padding: CGFloat) -> UIView {
		let border = UIView()
		addSubview(border)
		
		border.translatesAutoresizingMaskIntoConstraints = false
		border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		border.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
		border.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
		border.widthAnchor.constraint(equalToConstant: size).isActive = true
		
		return border
	}
}
