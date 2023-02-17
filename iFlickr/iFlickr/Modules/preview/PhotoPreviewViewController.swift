//
//  PhotoPreviewViewController.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import Kingfisher
import Cartography

class PhotoPreviewViewController: BaseViewController {

	// ************************************************
	// MARK: - @IBOutlets
	// ************************************************

	@IBOutlet private weak var loadingView: UIActivityIndicatorView!
	@IBOutlet private weak var footerView: GradientView!
	@IBOutlet private weak var footerTitleLabel: UILabel!

	// ImageView Constraints
	private var imageViewTopConstraint: NSLayoutConstraint!
	private var imageViewBottompConstraint: NSLayoutConstraint!
	private var imageViewLeadingConstraint: NSLayoutConstraint!
	private var imageViewTrailingConstraint: NSLayoutConstraint!

	// ************************************************
	// MARK: - Properties
	// ************************************************

	private let _viewModel: PhotoPreviewViewModelProtocol

	private var _isImageLoaded: Bool = false
	private var _isAnimating: Bool = false
	private var _lastLocation: CGPoint = .zero
	private var _maxZoomScale: CGFloat = 1.0

	// ************************************************
	// MARK: - UI Components
	// ************************************************

	private lazy var scrollView: UIScrollView = {
		let scrollView_ = UIScrollView()
		scrollView_.delegate = self
		scrollView_.backgroundColor = .clear
		scrollView_.showsVerticalScrollIndicator = false
		scrollView_.showsHorizontalScrollIndicator = false
		scrollView_.contentInsetAdjustmentBehavior = .never
		return scrollView_
	}()

	private lazy var imageView: UIImageView = {
		return UIImageView(frame: .zero)
	}()

	// ************************************************
	// MARK: - Lifecycle | Setup
	// ************************************************

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(viewModel: PhotoPreviewViewModelProtocol) {
		_viewModel = viewModel
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupNavigationBar()
		self.setupContentView()
		self.setupGestureRecognizers()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.loadImage()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		guard _isImageLoaded == false else { return }
		self.layoutSubviews()
	}

	private func setupNavigationBar() {
		// transparent bar
		let navigationBar = self.navigationController?.navigationBar
		navigationBar?.setBackgroundImage(UIImage(), for: .default)
		navigationBar?.shadowImage = UIImage()
		navigationBar?.isTranslucent = true
		navigationBar?.barTintColor = .clear
		navigationBar?.tintColor = .white
		navigationBar?.layer.shadowColor = nil
		navigationBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
		navigationBar?.layer.shadowRadius = 0
		navigationBar?.layer.shadowOpacity = 0
		navigationBar?.layer.masksToBounds = true

		// close button
		let closeButton = BarButton(
			image: Images.ic_close()!,
			action: { [weak self] in self?.close() }
		)
		self.navigationItem.leftBarButtonItem = closeButton
	}

	private func setupContentView() {
		// background
		view.backgroundColor = .black

		// scroll view
		view.addSubview(scrollView)
		constrain(scrollView, view) { (scroll, container) in scroll.edges == container.edges }

		// image view
		scrollView.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
		imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
		imageViewTrailingConstraint = scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
		imageViewBottompConstraint = scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
		// active anchors/constraints
		imageViewTopConstraint.isActive = true
		imageViewLeadingConstraint.isActive = true
		imageViewTrailingConstraint.isActive = true
		imageViewBottompConstraint.isActive = true

		// footer (gradient + title)
		self.view.bringSubviewToFront(footerView)
		footerView.colors = [UIColor.black.withAlphaComponent(0.9), UIColor.clear]
		footerView.orientation = GradientOrientation.bottomTop
		footerTitleLabel.text = _viewModel.photoTitle
	}

	private func setupGestureRecognizers() {
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
		panGesture.cancelsTouchesInView = false
		panGesture.delegate = self
		scrollView.addGestureRecognizer(panGesture)

		let pinchRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPinch(_:)))
		pinchRecognizer.numberOfTapsRequired = 1
		pinchRecognizer.numberOfTouchesRequired = 2
		scrollView.addGestureRecognizer(pinchRecognizer)

		let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSingleTap(_:)))
		singleTapGesture.numberOfTapsRequired = 1
		singleTapGesture.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(singleTapGesture)

		let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)

		singleTapGesture.require(toFail: doubleTapRecognizer)
	}

	// ************************************************
	// MARK: - Gesture Handlers
	// ************************************************

	@objc
	private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
		guard
			_isAnimating == false,
			scrollView.zoomScale == scrollView.minimumZoomScale
			else { return }

		let container: UIView! = imageView
		if gestureRecognizer.state == .began {
			_lastLocation = container.center
		}

		if gestureRecognizer.state != .cancelled {
			let translation: CGPoint = gestureRecognizer.translation(in: view)
			container.center = CGPoint(
				x: _lastLocation.x + translation.x,
				y: _lastLocation.y + translation.y
			)
		}

		let diffY = view.center.y - container.center.y
		self.view.alpha = 1.0 - abs(diffY/view.center.y)
		if gestureRecognizer.state == .ended {
			if abs(diffY) > 60 {
				self.close()
			} else {
				self.cancelAnimation()
			}
		}
	}

	@objc
	private func didPinch(_ recognizer: UITapGestureRecognizer) {
		var newZoomScale = scrollView.zoomScale / 1.5
		newZoomScale = max(newZoomScale, scrollView.minimumZoomScale)
		scrollView.setZoomScale(newZoomScale, animated: true)
	}

	@objc
	private func didSingleTap(_ recognizer: UITapGestureRecognizer) {
		navigationController?.isNavigationBarHidden = navigationController?.isNavigationBarHidden == false
		footerView.isHidden = footerView.isHidden == false
	}

	@objc
	private func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
		let pointInView = recognizer.location(in: imageView)
		zoomInOrOut(at: pointInView)
	}

	// ************************************************
	// MARK: - Layout
	// ************************************************

	private func layoutSubviews() {
		self.updateConstraintsForSize(view.bounds.size)
		self.updateMinMaxZoomScaleForSize(view.bounds.size)
	}

	private func updateConstraintsForSize(_ size: CGSize) {
		let yOffset = max(0, (size.height - imageView.frame.height) / 2)
		imageViewTopConstraint.constant = yOffset
		imageViewBottompConstraint.constant = yOffset

		let xOffset = max(0, (size.width - imageView.frame.width) / 2)
		imageViewLeadingConstraint.constant = xOffset
		imageViewTrailingConstraint.constant = xOffset
		view.layoutIfNeeded()
	}

	private func updateMinMaxZoomScaleForSize(_ size: CGSize) {
		let targetSize = imageView.bounds.size
		if targetSize.width == 0 || targetSize.height == 0 { return }

		let minScale = min(
			size.width/targetSize.width,
			size.height/targetSize.height
		)
		let maxScale = max(
			(size.width + 1.0) / targetSize.width,
			(size.height + 1.0) / targetSize.height
		)
		_maxZoomScale = maxScale

		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale
		scrollView.maximumZoomScale = _maxZoomScale * 1.1
	}

	private func zoomInOrOut(at point: CGPoint) {
		let newZoomScale = scrollView.zoomScale == scrollView.minimumZoomScale ?
			_maxZoomScale :
			scrollView.minimumZoomScale

		let size = scrollView.bounds.size
		let newWidth = size.width / newZoomScale
		let newHeight = size.height / newZoomScale
		let newX = point.x - (newWidth * 0.5)
		let newY = point.y - (newHeight * 0.5)
		let rect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
		scrollView.zoom(to: rect, animated: true)
	}

	// ************************************************
	// MARK: - Load Image
	// ************************************************

	private func loadImage() {
		loadingView.startAnimating()
		imageView.kf.setImage(
			with: _viewModel.photoUrl,
			options: [.transition(.fade(0.25))],
			completionHandler: { [weak self] result in
				if case Result.failure = result { self?.imageView.image = Images.placeholder() }
				self?.imageView.layoutIfNeeded()
				self?.layoutSubviews()
				self?.loadingView.stopAnimating()
				self?._isImageLoaded = true
			}
		)
	}

	// ************************************************
	// MARK: - Dismiss | Close
	// ************************************************

	private func cancelAnimation() {
		_isAnimating = true
		UIView.animate(
			withDuration: 0.237,
			animations: { [weak self] in
				self?.imageView.center = self?.view.center ?? CGPoint(x: 0, y: 0)
				self?.view.alpha = 1.0
			},
			completion: { [weak self] _ in
				self?._isAnimating = false
			}
		)
	}

	private func close() {
		self.navigationController?.dismiss(animated: true)
	}
}

// ************************************************
// MARK: - UIGestureRecognizerDelegate
// ************************************************

extension PhotoPreviewViewController: UIGestureRecognizerDelegate {

	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard scrollView.zoomScale == scrollView.minimumZoomScale,
			let panGesture = gestureRecognizer as? UIPanGestureRecognizer
			else { return false }

		let velocity = panGesture.velocity(in: scrollView)
		return abs(velocity.y) > abs(velocity.x)
	}
}

// ************************************************
// MARK: - UIScrollViewDelegate
// ************************************************

extension PhotoPreviewViewController: UIScrollViewDelegate {

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		self.updateConstraintsForSize(view.bounds.size)
	}
}
