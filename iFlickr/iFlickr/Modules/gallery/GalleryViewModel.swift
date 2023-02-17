//
//  GalleryViewModel.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxSwift
import RxCocoa

enum GalleryViewState {
	case idle
	case noResultsFound
	case reloadData(_ resetGridToTop: Bool)
	case error(Swift.Error)
}

protocol GalleryViewModelProtocol: BaseViewModelProtocol {
	var total: Int { get }
	var viewState: Driver<GalleryViewState> { get }
	var isLoading: Driver<Bool> { get }

	func photo(at index: Int) -> FlickrPhoto?
	func isLoaded(at index: Int) -> Bool

	func search(input: String)
	func nextPage()
	func stopSearch()

	func photoDidSelect(_ photo: FlickrPhoto)
}

final class GalleryViewModel: BaseViewModel, GalleryViewModelProtocol {

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _disposeBag = DisposeBag()

	private let _coordinator: GalleryCoordinatorProtocol.Type
	private let _repository: GalleryRepositoryProtocol

	var total: Int { _repository.total }

	private let _viewState = BehaviorRelay<GalleryViewState>(value: .idle)
	var viewState: Driver<GalleryViewState> { return _viewState.asDriver() }

	private let _isLoading = BehaviorRelay<Bool>(value: false)
	var isLoading: Driver<Bool> { return _isLoading.asDriver() }

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	init(coordinator: GalleryCoordinatorProtocol.Type, repository: GalleryRepositoryProtocol = GalleryRepository()) {
		_coordinator = coordinator
		_repository = repository

		super.init()
	}

	// ************************************************
	// MARK: - Data
	// ************************************************

	func photo(at index: Int) -> FlickrPhoto? {
		return _repository.photo(index: index)
	}

	func isLoaded(at index: Int) -> Bool {
		return index < _repository.loaded
	}

	func search(input: String) {
		_isLoading.accept(true)
		_repository
			.search(input: input)
			.do(onDispose: { [weak self] in self?._isLoading.accept(false) })
			.subscribe(
				onSuccess: { [weak self] photos in
					let viewState: GalleryViewState = photos.isEmpty ? .noResultsFound : .reloadData(true)
					self?._viewState.accept(viewState)
				},
				onError: { [weak self] error in
					if error is GalleryRepositoryError == false {
						self?._repository.stopSearch()
						self?._viewState.accept(.error(error))
					}
				}
			).disposed(by: _disposeBag)
	}

	func nextPage() {
		_repository
			.nextPage()
			.subscribe(
				onSuccess: { [weak self] photos in
					guard photos.isEmpty == false else { return }
					// We need to reload all data because each request might get a different result (total photos)
					// This avoid some crash during the reload grid 
					self?._viewState.accept(.reloadData(false))
				},
				onError: { [weak self] error in
					if error is GalleryRepositoryError == false {
						self?._repository.stopSearch()
						self?._viewState.accept(.error(error))
					}
				}
			).disposed(by: _disposeBag)
	}

	func stopSearch() {
		_repository.stopSearch()
		_viewState.accept(.idle)
	}

	// ************************************************
	// MARK: - Utils
	// ************************************************

	private func indexPathsToReload(from photos: [FlickrPhoto]) -> [IndexPath] {
		let startIndex = _repository.loaded - photos.count
		let endIndex = startIndex + photos.count
		return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
	}

	// ************************************************
	// MARK: - Navigation
	// ************************************************

	func photoDidSelect(_ photo: FlickrPhoto) {
		_coordinator.presentPhotoPreview(of: photo)
	}
}
