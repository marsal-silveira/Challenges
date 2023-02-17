//
//  StateView.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit
import Cartography

class StateView: NibView {

	// ************************************************
	// MARK: - Appearance
	// ************************************************

	struct Appearance {
		let backgroundColor: UIColor
		let titleColor: UIColor
		let subtitleColor: UIColor

		static var light: Appearance {
			return Appearance(
				backgroundColor: .white,
				titleColor: .black,
				subtitleColor: .black
			)
		}

		static var dark: Appearance {
			return Appearance(
				backgroundColor: .black,
				titleColor: .white,
				subtitleColor: .white
			)
		}
	}

	// ************************************************
	// MARK: - @IBOutlets
	// ************************************************

	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var subtitleLabel: UILabel!

	// ************************************************
	// MARK: - Lifecycle | Setup
	// ************************************************

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(image: UIImage? = nil, title: String, subtitle: String? = nil, appearance: Appearance = Appearance.light) {
		super.init()

		// setup
		contentView?.backgroundColor = backgroundColor

		imageView.image = image
		imageView.isHidden = image == nil

		titleLabel.text = title

		subtitleLabel.text = subtitle
		subtitleLabel.isHidden = subtitle == nil
	}

	// ************************************************
	// MARK: - Present | Dismiss
	// ************************************************

	func present(on parent: UIView) {
		parent.addSubview(self)
		constrain(self, parent) { (view, container) in
			view.leading == container.leading
			view.top == container.top
			view.trailing == container.trailing
			view.bottom == container.bottom
		}

		DispatchQueue.main.async {
			UIView.animate(
				withDuration: 0.25,
				animations: { [weak self] in self?.alpha = 1.0 }
			)
		}
	}

	func dismiss() {
		DispatchQueue.main.async { [weak self] in
			self?.removeFromSuperview()
		}
	}
}
