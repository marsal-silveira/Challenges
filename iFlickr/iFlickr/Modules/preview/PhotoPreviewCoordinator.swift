//
//  PhotoPreviewCoordinator.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

enum PhotoPreviewCoordinator {

	static func setup(photo: FlickrPhoto) -> UIViewController {
		let viewModel = PhotoPreviewViewModel(photo: photo)
		let viewController = PhotoPreviewViewController(viewModel: viewModel)

		return viewController
	}
}
