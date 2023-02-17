//
//  PhotoPreviewViewModel.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotoPreviewViewModelProtocol: BaseViewModelProtocol {
	var photoTitle: String { get }
	var photoUrl: URL? { get }
}

final class PhotoPreviewViewModel: BaseViewModel, PhotoPreviewViewModelProtocol {

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _disposeBag = DisposeBag()
	private let _photo: FlickrPhoto

	var photoTitle: String { return _photo.title }
	// if photo doesn't have "large" URL we try to load the "large Square" one
	var photoUrl: URL? { return _photo.largeURL ?? _photo.largeSquareURL }

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	init(photo: FlickrPhoto) {
		_photo = photo
		super.init()
	}
}
