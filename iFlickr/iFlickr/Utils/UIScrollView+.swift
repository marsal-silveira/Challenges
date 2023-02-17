//
//  UIScrollView+.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

extension UIScrollView {
	/// Sets content offset to the top.
	func resetScrollPositionToTop() {
		self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
	}
}
