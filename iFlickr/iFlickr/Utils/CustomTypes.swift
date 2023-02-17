//
//  CustomTypes.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation

// *************************************************
// MARK: - Wrapper
// *************************************************

typealias JSON = [String: Any]
typealias VoidClosure = () -> Void

// *************************************************
// MARK: - Operators
// *************************************************

// swiftlint:disable identifier_name
prefix operator ❗️
prefix func ❗️(a: Bool) -> Bool { return !a }
// swiftlint:enable identifier_name

// *************************************************
// MARK: - Resources (Wrapper to R.swift)
// *************************************************

typealias Strings = R.string.localizable
typealias Images = R.image
