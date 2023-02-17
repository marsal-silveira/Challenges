//
//  AppRouter.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

final class AppRouter: BaseViewController {

	// *************************************************
	// MARK: - Properties
	// *************************************************

	private var _currentViewController: UIViewController? {
		didSet {
			if let currentViewController = _currentViewController {

				currentViewController.willMove(toParent: self)
				self.addChild(currentViewController)
				currentViewController.didMove(toParent: self)

				if let oldViewController = oldValue {
					view.insertSubview(currentViewController.view, belowSubview: oldViewController.view)
				} else {
					view.addSubview(currentViewController.view)
				}
				currentViewController.view.frame = view.bounds
				currentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

				self.setNeedsStatusBarAppearanceUpdate()
			}

			if let oldViewController = oldValue {
				self.applyScreenTransition(newViewController: _currentViewController, oldViewController: oldViewController)
			}
		}
	}

	// *************************************************
	// MARK: - VC Transition
	// *************************************************

	private func applyScreenTransition(newViewController: UIViewController?, oldViewController: UIViewController) {
		if let newViewController = newViewController {
			newViewController.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.size.height))
			UIView.animate(
				withDuration: 0.8,
				delay: 0,
				usingSpringWithDamping: 0.8,
				initialSpringVelocity: 1,
				options: [],
				animations: {
					newViewController.view.transform = CGAffineTransform.identity
					oldViewController.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
				},
				completion: { [weak self] (finished) in
					self?.removeChild(oldViewController)
				}
			)
		} else {
			self.removeChild(oldViewController)
		}
	}

	// ************************************************
	// MARK: - Child ViewController
	// ************************************************

	override func addChild(_ childController: UIViewController) {
		childController.willMove(toParent: self)
		super.addChild(childController)
		childController.didMove(toParent: self)
	}

	private func removeChild(_ childController: UIViewController) {
		childController.willMove(toParent: nil)
		childController.view.removeFromSuperview()
		childController.removeFromParent()
		childController.didMove(toParent: nil)
	}
}

// ************************************************
// MARK: - AppRouter Protocol
// ************************************************

protocol AppRouterProtocol {
	func startup()
	func present(_ viewController: UIViewController, animated: Bool, completion: VoidClosure?)
}

extension AppRouterProtocol {
	// Just to give the `default` value for `animated` and `completion` params
	func present(_ viewController: UIViewController, animated: Bool = true, completion: VoidClosure? = nil) {
		self.present(viewController, animated: animated, completion: completion)
	}
}

extension AppRouter: AppRouterProtocol {

	func startup() {
		guard (_currentViewController is StartupViewController) == false else { return }

		let startup = StartupCoordinator.setup { [weak self] in
			let gallery = GalleryCoordinator.setup()
			let navigation = BaseNavigationController(rootViewController: gallery)
			self?._currentViewController = navigation
		}
		_currentViewController = startup
	}

	override func present(_ viewController: UIViewController, animated: Bool, completion: VoidClosure?) {
		_currentViewController?.present(viewController, animated: animated, completion: completion)
	}
}
