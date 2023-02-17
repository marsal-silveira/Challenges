//
//  GalleryRepository.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import RxSwift

struct FlickrPhoto: Equatable {
	let id: String
	let title: String
	let largeSquareURL: URL?
	let largeURL: URL?

	init (id: String, title: String, largeSquare: String?, large: String?) {
		self.id = id
		self.title = title

		if let largeSquarePath = largeSquare {
			self.largeSquareURL = URL(string: largeSquarePath)
		} else {
			self.largeSquareURL = nil
		}

		if let largePath = large {
			self.largeURL = URL(string: largePath)
		} else {
			self.largeURL = nil
		}
	}

	static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
		return lhs.id == rhs.id
	}
}

enum GalleryRepositoryError: ErrorProtocol {
	case isLoading
	case noMorePages
	case invalidInput

	var description: String {
		switch self {
			case .isLoading:
				return "There is another `loading` process running"
			case .noMorePages:
				return "All pages were loaded"
			case .invalidInput:
				return "The given `input` is invalid or empty"
		}
	}
}

protocol GalleryRepositoryProtocol {
	var total: Int { get }
	var loaded: Int { get }

	func photo(index: Int) -> FlickrPhoto?

	func search(input: String) -> Single<[FlickrPhoto]>
	func nextPage() -> Single<[FlickrPhoto]>
	func stopSearch()
}

class GalleryRepository: GalleryRepositoryProtocol {

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _disposeBag = DisposeBag()

	private let _api: FlickrApiProtocol
	private var _photos: [FlickrPhoto] = []

	private var _total: Int = 0
	private var _hasNext: Bool = true
	private var _page: Int = 0
	private var _isLoading: Bool = false
	private var _input: String?

	var total: Int {
		return _total
	}

	var loaded: Int {
		return _photos.count
	}

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	init(api: FlickrApiProtocol = FlickrApi()) {
		_api = api
	}

	// ************************************************
	// MARK: - Data
	// ************************************************

	func photo(index: Int) -> FlickrPhoto? {
		guard index >= 0 && index < _photos.count else { return nil }
		return _photos[index]
	}

	func search(input: String) -> Single<[FlickrPhoto]> {
		guard ServiceLocator.shared.networkReachabilityService.isReachable else { return Single.error(NetworkError.noConnection) }
		guard _isLoading == false else { return Single.error(GalleryRepositoryError.isLoading) }
		guard input.isNotEmpty, _input != input else { return Single.error(GalleryRepositoryError.invalidInput) }

		self.reset()

		_input = input
		_page += 1
		return load(input: input, page: _page)
	}

	func nextPage() -> Single<[FlickrPhoto]> {
		guard ServiceLocator.shared.networkReachabilityService.isReachable else { return Single.error(NetworkError.noConnection) }
		guard _isLoading == false else { return Single.error(GalleryRepositoryError.isLoading) }
		guard _hasNext else { return Single.error(GalleryRepositoryError.noMorePages) }
		guard let input = _input else { return Single.error(GalleryRepositoryError.invalidInput) }

		_page += 1
		return self.load(input: input, page: _page)
	}

	func stopSearch() {
		self.reset()
	}

	private func load(input: String, page: Int) -> Single<[FlickrPhoto]> {
		_isLoading = true
		return Single.create { [weak self] single in
			guard let self = self else {
				single(.error(GeneralError.unknown))
				return Disposables.create()
			}

			self._api
				.search(tag: input, page: page)
				.do(onDispose: { [weak self] in self?._isLoading = false })
				.subscribe(
					onSuccess: { response in
						var photos: [FlickrPhoto] = []

						// for each photo we need to get its sizes...
						// so we do an extra request using the `GetSizes` service
						let dispatchGroup = DispatchGroup()
						for rawPhoto in response.photos {
							dispatchGroup.enter()
							self._api
								.getSizes(photoId: rawPhoto.id)
								.do(onDispose: { dispatchGroup.leave() })
								.subscribe(onSuccess: { response in
									photos.append(
										FlickrPhoto(
											id: rawPhoto.id,
											title: rawPhoto.title,
											largeSquare: response.sizes.getLargeSquare()?.source,
											large: response.sizes.getLarge()?.source
										)
									)
								}).disposed(by: self._disposeBag)
						}

						// wait until all photo are loaded
						dispatchGroup.notify(queue: .main) {
							self._photos.append(contentsOf: photos)
							self._total = response.total
							self._page = response.page
							self._hasNext = self._photos.count < self._total

							single(.success(photos))
						}
					},
					onError: { [weak self] error in
						self?.stopSearch()
						single(.error(error))
					}
				).disposed(by: self._disposeBag)

			return Disposables.create()
		}
	}

	private func reset() {
		_input = nil
		_photos.removeAll()
		_total = 0
		_page = 0
		_isLoading = false
		_hasNext = true
	}
}
