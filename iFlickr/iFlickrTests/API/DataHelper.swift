//
//  DataHelper.swift
//  iFlickrTests
//
//  Created by Marsal Silveira.
//

import Foundation
import Moya

/// This must be a `class` type because to allow us get TestTarget bundle (class type requirement)
class DataHelper {

	private init() {}

	static func data(fromJsonString jsonStr: String) -> Data {
		guard let data = jsonStr.data(using: String.Encoding.utf8) else {
			fatalError("can't get data from json string input")
		}
		return data
	}

	static func data(fromJsonFile fileName: String) -> Data {
		var data: Data
		if let path = Bundle(for: DataHelper.self).path(forResource: fileName, ofType: "json") {
			do {
				let fileUrl = URL(fileURLWithPath: path)
				data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
				return data
			} catch {
				fatalError("can't be possible get json data from mock file \(fileName).")
			}
		}
		fatalError("json mock file not found. \(fileName)")
	}
}
