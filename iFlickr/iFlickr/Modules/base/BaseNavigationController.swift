//
//  BaseNavigationController.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupOnLoad()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	private func setupOnLoad() {

//		// replace back button
//		self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_back")
//		self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_back")

		// make navigation bar transparent
		self.makeNavigationBarTransparent()
	}

	private func makeNavigationBarTransparent() {
		navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationBar.shadowImage = UIImage()
		navigationBar.isTranslucent = true
		navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		navigationBar.tintColor = UIColor.white
		view.backgroundColor = .clear
	}
}
