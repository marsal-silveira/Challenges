//
//  FlickrApiSearch.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

extension FlickrApi {

	struct Search: BaseApiTarget {

		private let _tag: String
		private let _page: Int
		private let _pageSize: Int

		var baseURL: URL { return FlickrApi.baseURL }
		var path: String { return "" }
		let method: Moya.Method = .get
		var task: Task {
			return .requestParameters(
				parameters: [
					"method": "flickr.photos.search",
					"api_key": FlickrApi.apiKey,
					"tags": _tag,
					"page": _page,
					"format": "json",
					"nojsoncallback": 1,
					"per_page": _pageSize
				],
				encoding: URLEncoding.queryString
			)
		}

		init(tag: String, page: Int, pageSize: Int = 50) {
			_tag = tag
			_page = page
			_pageSize = pageSize
		}
	}
}

extension FlickrApi.Search {

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
		guard let dataJSON = json["photos"] as? JSON else {
			throw DecodingError.keyNotFound(key: "photos", entity: "FlickrApi.Search.Response")
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

extension FlickrApi.Search {

	struct Response: Codable {

		struct Fail: ErrorProtocol {
			let code: Int
			let message: String

			var description: String {
				return message
			}
		}

		struct Photo: Codable {
			var id: String
			var title: String
		}

		var page: Int
		var pages: Int
		var total: Int
		var photos: [Photo]

		enum CodingKeys: String, CodingKey {
			case page
			case pages
			case total
			case photos = "photo"
		}
	}
}
