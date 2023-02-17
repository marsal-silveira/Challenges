//
//  BarButton.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

class BarButton: UIBarButtonItem {

	typealias Action = VoidClosure
	private var _action: BarButton.Action?
	@objc private func actionHandler() {
		_action?()
	}

	convenience init(title: String, action closure: @escaping BarButton.Action) {
		self.init(title: title, style: .done, target: nil, action: nil)
		self.target = self
		self.action = #selector(actionHandler)
		_action = closure
	}

	convenience init(image: UIImage, action closure: @escaping BarButton.Action) {
		self.init(image: image, style: .done, target: nil, action: nil)
		self.target = self
		self.action = #selector(actionHandler)
		_action = closure
	}
}
