//
//  GalleryCell.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import Kingfisher

class GalleryCell: UICollectionViewCell {
	@IBOutlet private weak var thumbnailImage: UIImageView!
	@IBOutlet private weak var loadingView: UIActivityIndicatorView!
	@IBOutlet private weak var gradientView: GradientView!
	@IBOutlet private weak var titleLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		// thumbnail + loading indicator
		thumbnailImage.image = nil
		loadingView.stopAnimating()

		// gradient + title
		gradientView.colors = [UIColor.black.withAlphaComponent(0.9), UIColor.clear]
		gradientView.orientation = GradientOrientation.bottomTop
		gradientView.isHidden = true
		titleLabel.text = nil
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		// reset thumbnail and title
		thumbnailImage.kf.cancelDownloadTask()
		thumbnailImage.image = nil
		gradientView.isHidden = true
		titleLabel.text = nil
	}

	func setupLoading() {
		loadingView.startAnimating()
	}

	func setup(photo: FlickrPhoto) {
		thumbnailImage.kf.setImage(
			with: photo.largeSquareURL,
			placeholder: Images.placeholder(),
			options: [.transition(.fade(0.25))],
			completionHandler: { [weak self] _ in self?.loadingView.stopAnimating() }
		)
		gradientView.isHidden = false
		titleLabel.text = photo.title
	}
}
