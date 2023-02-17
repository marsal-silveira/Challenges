//
//  FlickrApiGetSizesTests.swift
//  iFlickrTests
//
//  Created by Marsal Silveira.
//

import Foundation
import XCTest
import RxSwift
import Moya

@testable import iFlickr

class FlickrApiGetSizesTests: XCTestCase {

	private let _disposeBag = DisposeBag()

	func test_Success() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Success")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiGetSizes_Success"))
			.getSizes(photoId: "31456463045")
			.subscribe { event in
				switch event {
				case .success(let response):
					// sizes
					XCTAssertFalse(response.sizes.isEmpty, "Expected response.sizes.isEmpty -> false | Received -> \(response.sizes.isEmpty)")
					XCTAssertEqual(response.sizes.count, 16, "Expected response.sizes.count -> 16 | Received -> \(response.sizes.count)")

				case .error(let error):
					XCTFail("Unexpected result -> .error -> \(error)")
				}

				// when it finishes, mark my expectation as being fulfilled
				expectation.fulfill()
			}
			.disposed(by: _disposeBag)

		// wait for all outstanding expectations to be fulfilled
		self.waitForExpectations(timeout: 1)
	}

	func test_Success_NoResultsFound() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Success_NoResultsFound")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiGetSizes_Success_NoResultsFound"))
			.getSizes(photoId: "31456463045")
			.subscribe { event in
				switch event {
				case .success(let response):
					// sizes
					XCTAssertTrue(response.sizes.isEmpty, "Expected response.sizes.isEmpty -> true | Received -> \(response.sizes.isEmpty)")
					XCTAssertEqual(response.sizes.count, 0, "Expected response.sizes.count -> 0 | Received -> \(response.sizes.count)")

				case .error(let error):
					XCTFail("Unexpected result -> .error -> \(error)")
				}

				// when it finishes, mark my expectation as being fulfilled
				expectation.fulfill()
			}
			.disposed(by: _disposeBag)

		// wait for all outstanding expectations to be fulfilled
		self.waitForExpectations(timeout: 1)
	}

	func test_Fail() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Fail")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiGetSizes_Fail"))
			.getSizes(photoId: "31456463045")
			.subscribe { event in
				switch event {
					case .error(let error):
						guard let decodingError = error as? DecodingError, case DecodingError.keyNotFound = decodingError else {
							XCTFail("Unexpected result -> .error -> \(error)")
							return
						}
					case .success:
						XCTFail("Unexpected result -> .success")
				}

				// when it finishes, mark my expectation as being fulfilled
				expectation.fulfill()
			}
			.disposed(by: _disposeBag)

		// wait for all outstanding expectations to be fulfilled
		self.waitForExpectations(timeout: 1)
	}

	func test_Fail_InvalidApiKey() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Fail_InvalidApiKey")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiGetSizes_Fail_InvalidApiKey"))
			.search(tag: "tag", page: 1)
			.subscribe { event in
				switch event {
					case .error(let error):
						guard let fail = error as? FlickrApi.Search.Response.Fail else {
							XCTFail("Unexpected result -> .error -> \(error)")
							return
						}
						// code
						XCTAssertEqual(fail.code, 100, "Expected fail.code -> 100 | Received -> \(fail.code)")
					case .success:
						XCTFail("Unexpected result -> .success")
				}

				// when it finishes, mark my expectation as being fulfilled
				expectation.fulfill()
			}
			.disposed(by: _disposeBag)

		// wait for all outstanding expectations to be fulfilled
		self.waitForExpectations(timeout: 1)
	}

	func test_Fail_MethodNotFound() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Fail_MethodNotFound")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiGetSizes_Fail_MethodNotFound"))
			.search(tag: "tag", page: 1)
			.subscribe { event in
				switch event {
					case .error(let error):
						guard let fail = error as? FlickrApi.Search.Response.Fail else {
							XCTFail("Unexpected result -> .error -> \(error)")
							return
						}
						// code
						XCTAssertEqual(fail.code, 112, "Expected fail.code -> 112 | Received -> \(fail.code)")
					case .success:
						XCTFail("Unexpected result -> .success")
				}

				// when it finishes, mark my expectation as being fulfilled
				expectation.fulfill()
			}
			.disposed(by: _disposeBag)

		// wait for all outstanding expectations to be fulfilled
		self.waitForExpectations(timeout: 1)
	}
}
