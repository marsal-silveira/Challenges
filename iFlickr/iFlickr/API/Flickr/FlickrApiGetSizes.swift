//
//  FlickrApiGetSizes.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension FlickrApi {

	struct GetSizes: BaseApiTarget {

		private let _photoId: String

		var baseURL: URL { return FlickrApi.baseURL }
		var path: String { return "" }
		let method: Moya.Method = .get
		var task: Task {
			return .requestParameters(
				parameters: [
					"method": "flickr.photos.getSizes",
					"api_key": FlickrApi.apiKey,
					"photo_id": _photoId,
					"format": "json",
					"nojsoncallback": 1
				],
				encoding: URLEncoding.queryString
			)
		}

		init(photoId: String) {
			_photoId = photoId
		}
	}
}

extension FlickrApi.GetSizes {

	static func parse(response moyaResponse: Moya.Response) throws -> Response {

		// get JSON
		let json: JSON
		do {
			json = try JSONSerialization.jsonObject(with: moyaResponse.data, options: []) as? JSON ?? [:]
		} catch {
			throw DecodingError.wrongFormat
		}

		// check the `stat` property
		let stat = json["stat"] as? String
		guard stat == "ok" else {
			let code = json["code"] as? Int ?? -1
			let message = json["message"] as? String ?? "null"
			throw Response.Fail(code: code, message: message)
		}

		// get response data
		guard let dataJSON = json["sizes"] as? JSON else {
			throw DecodingError.keyNotFound(key: "sizes", entity: "FlickrApi.GetSizes.Response")
		}
		guard let data = try? JSONSerialization.data(withJSONObject: dataJSON, options: []) else {
			throw DecodingError.wrongFormat
		}
		guard let response = try? JSONDecoder().decode(Response.self, from: data) else {
			throw DecodingError.wrongFormat
		}

		return response
	}
}

extension FlickrApi.GetSizes {

	struct Response: Codable {

		struct Fail: ErrorProtocol {
			let code: Int
			let message: String

			var description: String {
				return message
			}
		}

		struct Size: Codable {
			var label: String
			var source: String

			fileprivate enum Label: String {
				case square = "Square"
				case largeSquare = "Large Square"
				case thumbnail = "Thumbnail"
				case small = "Small"
				case small_320 = "Small 320"
				case small_400 = "Small 400"
				case medium = "Medium"
				case medium_640 = "Medium 640"
				case medium_800 = "Medium 800"
				case large = "Large"
				case large_1600 = "Large 1600"
				case large_2048 = "Large 2048"
				case xLarge_3K = "X-Large 3K"
				case xLarge_4K = "X-Large 4K"
				case xLarge_5K = "X-Large 5K"
				case original = "Original"

				func toString() -> String {
					return self.rawValue
				}
			}
		}

		var sizes: [Size]

		enum CodingKeys: String, CodingKey {
			case sizes = "size"
		}
	}
}

extension Collection where Element == FlickrApi.GetSizes.Response.Size {

	func getLargeSquare() -> Element? {
		return self.first { size in size.label == FlickrApi.GetSizes.Response.Size.Label.largeSquare.toString() }
	}

	func getLarge() -> Element? {
		return self.first { size in size.label == FlickrApi.GetSizes.Response.Size.Label.large.toString() }
	}
}
