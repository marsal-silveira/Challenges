//
//  BaseApiTarget.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import Moya

protocol BaseApiTarget: TargetType { }

extension BaseApiTarget {

	var headers: [String: String]? {
		return [
			"Content-Type": "application/json",
			"Accept": "application/json"
		]
	}

	var path: String {
		return ""
	}

	var sampleData: Data {
		return Data()
	}
}
