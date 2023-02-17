//
//  GalleryCoordinator.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

enum GalleryCoordinator {

	static func setup() -> UIViewController {
		let viewModel = GalleryViewModel(coordinator: Self.self)
		let viewController = GalleryViewController(viewModel: viewModel)

		return viewController
	}
}

// ************************************************
// MARK: - GalleryCoordinator Protocol
// ************************************************

protocol GalleryCoordinatorProtocol {
	static func presentPhotoPreview(of photo: FlickrPhoto)
}

extension GalleryCoordinator: GalleryCoordinatorProtocol {

	static func presentPhotoPreview(of photo: FlickrPhoto) {
		let preview = PhotoPreviewCoordinator.setup(photo: photo)
		let previewNavigation = BaseNavigationController(rootViewController: preview)
		previewNavigation.modalPresentationStyle = .custom
		previewNavigation.modalTransitionStyle = .crossDissolve

		ServiceLocator.shared.appRouter.present(previewNavigation)
	}
}
