//
//  StartupCoordinator.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

enum StartupCoordinator {

	static func setup(onCompletion: @escaping VoidClosure) -> UIViewController {
		let viewModel = StartupViewModel(onCompletion: onCompletion)
		let viewController = StartupViewController(viewModel: viewModel)

		return viewController
	}
}
