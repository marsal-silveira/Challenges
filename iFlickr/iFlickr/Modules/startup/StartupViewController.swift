//
//  StartupViewController.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

final class StartupViewController: BaseViewController {

	// ************************************************
	// MARK: - @IBOutlets
	// ************************************************

	@IBOutlet private weak var logoImage: UIImageView!

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _viewModel: StartupViewModelProtocol

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(viewModel: StartupViewModelProtocol) {
		_viewModel = viewModel

		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupOnLoad()
	}

	// ************************************************
	// MARK: - Setup
	// ************************************************

	private func setupOnLoad() {
		// start loading (logo) and the setup process
		logoImage.rotate()
		_viewModel.setup()
	}
}
