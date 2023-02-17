//
//  GradientView.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import UIKit

// Gradient Points
typealias GradientPoints = (x: CGPoint, y: CGPoint)

// Gradient Orientation
enum GradientOrientation {
	case leftRight
	case rightLeft
	case topBottom
	case bottomTop
	case topLeftBottomRight
	case bottomRightTopLeft
	case topRightBottomLeft
	case bottomLeftTopRight

	var points: GradientPoints {
		switch self {
		case .leftRight:
			return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
		case .rightLeft:
			return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
		case .topBottom:
			return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
		case .bottomTop:
			return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
		case .topLeftBottomRight:
			return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
		case .bottomRightTopLeft:
			return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
		case .topRightBottomLeft:
			return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
		case .bottomLeftTopRight:
			return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
		}
	}
}

// Gradient View
class GradientView: UIView {

	init() {
		super.init(frame: CGRect.zero)
	}

	// (Private) Gradient Layer
	private class GradientLayer: CAGradientLayer {

		var orientation: GradientOrientation = .topBottom {
			didSet {
				startPoint = orientation.points.x
				endPoint = orientation.points.y
			}
		}
	}

	override class var layerClass: Swift.AnyClass {
		return GradientLayer.self
	}

	private var gradientLayer: GradientLayer {
		// swiftlint:disable:next force_cast
		return layer as! GradientLayer
	}

	var orientation: GradientOrientation {
		get {
			return gradientLayer.orientation
		}
		set {
			gradientLayer.orientation = newValue
		}
	}

	var colors: [UIColor]? {
		get {
			return gradientLayer.colors?.map({ (color) -> UIColor in
				// swiftlint:disable:next force_cast
				let cgColor = (color as! CGColor)
				return UIColor(cgColor: cgColor)
			})
		}
		set {
			gradientLayer.colors = newValue?.map({ (color) -> CGColor in color.cgColor })
		}
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		// this is necessary to get a transparent background when we applied the colors
		backgroundColor = UIColor.clear
	}
}
