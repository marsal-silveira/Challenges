//
//  UIView+Animation.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

extension UIView {
	func rotate() {
		let rotation = CABasicAnimation(keyPath: "transform.rotation")
		rotation.fromValue = 0.0
		rotation.toValue = Double.pi * 2
		rotation.duration = 1
		rotation.isCumulative = true
		rotation.repeatCount = .infinity
		self.layer.add(rotation, forKey: "rotationAnimation")
	}
}
