//
//  BaseApi.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation

protocol BaseApi {
	static var basePath: String { get }
	static var baseURL: URL { get }
}

extension BaseApi {

	static var baseURL: URL {
		guard let url = URL(string: basePath) else { fatalError("\(String(describing: Self.self)).baseURL may not be configured") }
		return url
	}
}
