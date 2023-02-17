//
//  GalleryViewController.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import RxSwift

final class GalleryViewController: BaseViewController {

	// ************************************************
	// MARK: - @IBOutlets
	// ************************************************

	@IBOutlet private weak var contentContainer: UIView!
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!

	private var _stateView: StateView?

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _viewModel: GalleryViewModelProtocol

	private let _disposeBag = DisposeBag()
	private var _isLoading = false

	override var navigationBarLargeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode {
		return .always
	}

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(viewModel: GalleryViewModelProtocol) {
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
		self.title = Strings.galleryNavigationTitle()

		self.setupSearchBar()
		self.setupCollectionView()

		// loading indicator
		_viewModel
			.isLoading
			.drive(onNext: { [weak self] isLoading in
				if isLoading {
					self?.loadingIndicatorView.startAnimating()
					self?._stateView?.dismiss()
				} else {
					self?.loadingIndicatorView.stopAnimating()
				}
			}).disposed(by: _disposeBag)

		// view state
		_viewModel
			.viewState
			.do(onNext: { [weak self] _ in self?._isLoading = false })
			.drive(onNext: { [weak self] result in
				switch result {
					case .idle:
						self?.updateViewState_idle()
					case .noResultsFound:
						self?.updateViewState_noResultsFound()
					case .reloadData(let resetGridToTop):
						self?.updateViewState_reloadData(resetGridToTop: resetGridToTop)
					case .error(let error):
						self?.updateViewState_error(error)
				}
			}).disposed(by: _disposeBag)
	}

	private func setupSearchBar() {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = Strings.gallerySearchBarPlaceholder()
		searchController.searchBar.tintColor = .label
		self.navigationItem.searchController = searchController
	}

	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.prefetchDataSource = self
		collectionView.backgroundColor = .clear
		collectionView.registerCell(GalleryCell.self)
		collectionView.setCollectionViewLayout(CollectionViewGridLayout(numberOfColumns: 2, cellPadding: 6), animated: true)
	}

	// ************************************************
	// MARK: - ViewState Update
	// ************************************************

	private func showStateView(_ stateView: StateView) {
		_stateView?.dismiss()
		_stateView = stateView
		_stateView?.present(on: self.contentContainer)
	}

	private func updateViewState_idle() {
		self.showStateView(StateView(title: Strings.galleryViewStateIdleTitle()))
		self.reloadData(resetGridToTop: true)
	}

	private func updateViewState_noResultsFound() {
		self.showStateView(StateView(title: Strings.galleryViewStateNoResultsFoundTitle(), subtitle: Strings.galleryViewStateNoResultsFoundSubtitle()))
		self.reloadData(resetGridToTop: true)
	}

	private func updateViewState_reloadData(resetGridToTop: Bool) {
		self._stateView?.dismiss()
		self.reloadData(resetGridToTop: resetGridToTop)
	}

	private func updateViewState_error(_ error: Error) {
		self.showStateView(StateView(title: Strings.errorGeneral(), subtitle: error.localizedDescription))
		self.reloadData(resetGridToTop: true)
	}

	// ************************************************
	// MARK: - Data
	// ************************************************

	private func search(input: String) {
		_isLoading = true
		_viewModel.search(input: input)
	}

	private func nextPage() {
		_isLoading = true
		_viewModel.nextPage()
	}

	private func reloadData(resetGridToTop: Bool) {
		if resetGridToTop { self.collectionView.resetScrollPositionToTop() }
		self.collectionView.reloadData()
	}

	// ************************************************
	// MARK: - Utils
	// ************************************************

	private func indexPathsForVisibleItems(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
		let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
		let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
		return Array(indexPathsIntersection)
	}
}

// ************************************************
// MARK: - UICollectionViewDataSource
// ************************************************

extension GalleryViewController: UICollectionViewDataSource {

	private func isCellLoading(for indexPath: IndexPath) -> Bool {
		return _viewModel.isLoaded(at: indexPath.row) == false
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return _viewModel.total
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as GalleryCell

		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }

			// [PAGINATION] if cell is loading we show the "LoadingCell" instead of "PhotoCell"
			if self.isCellLoading(for: indexPath) {
				cell.setupLoading()
			} else {
				guard let photo = self._viewModel.photo(at: indexPath.row) else { return }
				cell.setup(photo: photo)
			}
		}

		return cell
	}
}

// ************************************************
// MARK: - UICollectionViewDelegate
// ************************************************

extension GalleryViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let photo = _viewModel.photo(at: indexPath.row) else { return }
		_viewModel.photoDidSelect(photo)
	}
}

// ************************************************
// MARK: - UITableViewDataSourcePrefetching
// ************************************************

extension GalleryViewController: UICollectionViewDataSourcePrefetching {

	func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
		if _isLoading == false {
			// [PAGINATION] if there is some cell `loading` we try load next page
			if indexPaths.contains(where: self.isCellLoading) {
				self.nextPage()
			}
		}
	}
}

// ************************************************
// MARK: - UICollectionViewDelegateFlowLayout
// ************************************************\

extension GalleryViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath) -> CGSize {

		guard let gridLayout = collectionViewLayout as? CollectionViewGridLayout else { return CGSize.zero }
		return gridLayout.cellSize(forItemAt: indexPath)
	}
}

// ************************************************
// MARK: - UISearchBarDelegate
// ************************************************

extension GalleryViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let input = searchBar.text else { return }
		self.search(input: input)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		_viewModel.stopSearch()
	}
}
