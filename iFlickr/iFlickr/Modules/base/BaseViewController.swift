//
//  BaseViewController.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import Cartography
import RxSwift

class BaseViewController: UIViewController {

	// ************************************************
	// MARK: - Properties
	// ************************************************

	var navigationBarLargeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
		// default value... if any descendant class needs another value this method must be override
		return .never
	}

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(nibName: String? = nil) {
		super.init(nibName: nibName, bundle: nil)
		Logger.debug("🆕 ---> \(String(describing: type(of: self)))")
	}

	deinit {
		Logger.debug("☠️ ---> \(String(describing: type(of: self)))")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.largeTitleDisplayMode = self.navigationBarLargeTitleDisplayMode
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}
