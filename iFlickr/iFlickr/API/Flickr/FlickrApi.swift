//
//  FlickrApi.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import Moya
import RxSwift

protocol FlickrApiProtocol: BaseApi {
	func search(tag: String, page: Int) -> Single<FlickrApi.Search.Response>
	func getSizes(photoId: String) -> Single<FlickrApi.GetSizes.Response>
}

class FlickrApi: FlickrApiProtocol {

	static let basePath = "https://api.flickr.com/services/rest"
	static let apiKey = "f9cc014fa76b098f9e82f1c288379ea1"

	private let _alfredo: Alfredo

	init(alfredo: Alfredo = Alfredo()) {
		_alfredo = alfredo
	}

	// *************************************************
	// MARK: - EndPoints
	// *************************************************

	func search(tag: String, page: Int) -> Single<FlickrApi.Search.Response> {
		return _alfredo.rx
			.request(target: FlickrApi.Search(tag: tag, page: page))
			.timeout(Alfredo.Timeout.short, scheduler: MainScheduler.instance)
			.validateStatusCode(.successCodes)
			.map(FlickrApi.Search.parse)
	}

	func getSizes(photoId: String) -> Single<FlickrApi.GetSizes.Response> {
		return _alfredo.rx
			.request(target: FlickrApi.GetSizes(photoId: photoId))
			.timeout(Alfredo.Timeout.short, scheduler: MainScheduler.instance)
			.validateStatusCode(.successCodes)
			.map(FlickrApi.GetSizes.parse)
	}
}
