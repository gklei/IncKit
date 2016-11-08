//
//  UIViewController+AlertPresenting.swift
//  IncipiaKit
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import UIKit

private class ErrorPresenterViewController: UIViewController {
	private var _isVisible = false
	private lazy var _okAction: UIAlertAction = {
		return UIAlertAction(title: "OK", style: .default, handler: nil)
	}()
	
	private func _okAction(completion: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
		return UIAlertAction(title: "OK", style: .default, handler: completion)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.alpha = 0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		_isVisible = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		_isVisible = false
	}
	
	override func present(error: NSError, completion: ((UIAlertAction) -> Void)? = nil) {
		guard _isVisible == true else { return }
		let alertController = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .alert)
		alertController.addAction(_okAction(completion: completion))
		present(alertController, animated: true, completion: nil)
	}
	
	override func presentMessage(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
		guard _isVisible == true else { return }
		let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
		alertController.addAction(_okAction(completion: completion))
		present(alertController, animated: true, completion: nil)
	}
}

public extension UIViewController {
	private var errorPresenter: ErrorPresenterViewController {
		for viewController in childViewControllers {
			if let presenter = viewController as? ErrorPresenterViewController {
				return presenter
			}
		}
		return _createAndAddErrorPresenter()
	}
	
	private func _createAndAddErrorPresenter() -> ErrorPresenterViewController {
		let errorPresenter = ErrorPresenterViewController()
		addChildViewController(errorPresenter)
		errorPresenter.didMove(toParentViewController: self)
		
		view.addSubview(errorPresenter.view)
		return errorPresenter
	}
	
	public func present(error: NSError, completion: ((UIAlertAction) -> Void)? = nil) {
		DispatchQueue.main.async {
			self.errorPresenter.present(error: error, completion: completion)
		}
	}
	
	public func presentMessage(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
		DispatchQueue.main.async {
			self.errorPresenter.presentMessage(message: message, completion: completion)
		}
	}
	
	// MARK: - Bar Button Items
	public func removeLeftBarItem() {
		navigationItem.setLeftBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func removeRightBarItem() {
		navigationItem.setRightBarButtonItems([UIBarButtonItem.empty], animated: false)
	}
	
	public func usePlainArrowForBackButtonItem(withAction action: Selector? = nil) {
		let itemAction = action ?? #selector(UIViewController.ik_backButtonPressed)
		let item = UIBarButtonItem.back(target: self, action: itemAction)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateLeftBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withImageName name: String, action: Selector) {
		let item = UIBarButtonItem(image: UIImage(named: name), style: .plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	public func updateLeftBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
		navigationItem.setLeftBarButtonItems([item], animated: false)
	}
	
	public func updateRightBarButtonItem(withTitle title: String, action: Selector) {
		let item = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
		navigationItem.setRightBarButtonItems([item], animated: false)
	}
	
	@objc private func ik_backButtonPressed() {
		let _ = navigationController?.popViewController(animated: true)
	}
	
	// MARK: - Navigation Bar
	public func makeNavBarTransparent() {
		navigationController?.makeNavBarTransparent()
	}
	
	public func removeNavBarShadow() {
		navigationController?.removeNavBarShadow()
	}
	
	public func resetNavBarTransparency() {
		navigationController?.resetNavBarTransparency()
	}
	
	public func resetNavBarShadow() {
		navigationController?.resetNavBarShadow()
	}
   
   public func updateNavBarShadow(with color: UIColor) {
      navigationController?.updateNavBarShadow(with: color)
   }
	
	// MARK: - Child View Controllers
	func add(childViewController vc: UIViewController, toContainer container: UIView) {
		addChildViewController(vc)
		container.addAndFill(subview: vc.view)
		vc.didMove(toParentViewController: self)
	}
	
	// MARK: - Initialization
	public static var className: String {
		let classString = NSStringFromClass(self)
		let components = classString.components(separatedBy: ".")
		assert(components.count > 0, "Failed extract class name from \(classString)")
		return components.last!
	}
	
	// This method only works if the view controller's ID is the same as the class name
	public class func instantiate(fromStoryboard name: String) -> Self {
		let storyboard = UIStoryboard(name: name, bundle: nil)
		return instantiateFromStoryboard(storyboard: storyboard, type: self)
	}
	
	private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
      guard let vc = storyboard.instantiateViewController(withIdentifier: className) as? T else {
         fatalError("Could not create class type \(T.self) widh identifier \(className)")
      }
      return vc
	}
}

public extension UIViewControllerContextTransitioning {
	public var toViewController: UIViewController? {
		return viewController(forKey: UITransitionContextViewControllerKey.to)
	}
	
	public var fromViewController: UIViewController? {
		return viewController(forKey: UITransitionContextViewControllerKey.from)
	}
}
