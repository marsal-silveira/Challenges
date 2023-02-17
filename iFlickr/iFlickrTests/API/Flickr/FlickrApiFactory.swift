//
//  FlickrApiFactory.swift
//  iFlickrTests
//
//  Created by Marsal Silveira.
//

import Foundation

@testable import iFlickr

enum FlickrApiFactory {

	static func getAPI(responseCode: Int = 200, responseData: Data) -> FlickrApiProtocol {
		let alfredo = Alfredo(provider: StubbedMoyaProvider(responseCode: responseCode, responseData: responseData))
		return FlickrApi(alfredo: alfredo)
	}
}
