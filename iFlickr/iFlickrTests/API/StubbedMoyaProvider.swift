//
//  StubbedMoyaProvider.swift
//  iFlickrTests
//
//  Created by Marsal Silveira.
//

import Foundation
import Moya

class StubbedMoyaProvider: MoyaProvider<MultiTarget> {

	init(responseCode: Int, responseData: Data = Data()) {
		super.init(
			endpointClosure: { (target) -> Endpoint in
				return Endpoint(
					url: URL(target: target).absoluteString,
					sampleResponseClosure: { .networkResponse(responseCode, responseData) },
					method: target.method,
					task: target.task,
					httpHeaderFields: target.headers
				)
			},
			stubClosure: MoyaProvider.immediatelyStub
		)
	}
}
