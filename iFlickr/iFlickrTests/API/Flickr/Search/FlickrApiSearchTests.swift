//
//  FlickrApiTests.swift
//  iFlickrTests
//
//  Created by Marsal Silveira.
//

import Foundation
import XCTest
import RxSwift
import Moya

@testable import iFlickr

class FlickrApiTests: XCTestCase {

	private let _disposeBag = DisposeBag()

	func test_Success_Page1() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Success_Page1")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Success_Page1"))
			.search(tag: "tag", page: 1)
			.subscribe { event in
				switch event {
				case .success(let response):
					// total
					XCTAssertEqual(response.total, 6, "Expected response.total -> 6 | Received -> \(response.total)")
					// pages
					XCTAssertEqual(response.pages, 2, "Expected response.pages -> 2 | Received -> \(response.pages)")
					// photos
					XCTAssertFalse(response.photos.isEmpty, "Expected response.photos.isEmpty -> false | Received -> \(response.photos.isEmpty)")
					XCTAssertEqual(response.photos.count, 4, "Expected response.photos.count -> 4 | Received -> \(response.photos.count)")
					let photosIds = response.photos.map { photo in photo.id }
					let photosIdsExpected = ["51264245484", "51262506851", "51262694248", "51255899949"]
					XCTAssertEqual(photosIds, photosIdsExpected, "Expected photosId -> \(photosIdsExpected) | Received -> \(photosIds)")

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

	func test_Success_Page2() {
		// use this to make synchronous an async call (Rx)
		let expectation = self.expectation(description: "test_Success_Page2")

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Success_Page2"))
			.search(tag: "tag", page: 1)
			.subscribe { event in
				switch event {
				case .success(let response):
					// total
					XCTAssertEqual(response.total, 6, "Expected response.total -> 6 | Received -> \(response.total)")
					// pages
					XCTAssertEqual(response.pages, 2, "Expected response.pages -> 2 | Received -> \(response.pages)")
					// photos
					XCTAssertFalse(response.photos.isEmpty, "Expected response.photos.isEmpty -> false | Received -> \(response.photos.isEmpty)")
					XCTAssertEqual(response.photos.count, 2, "Expected response.photos.count -> 2 | Received -> \(response.photos.count)")
					let photosIds = response.photos.map { photo in photo.id }
					let photosIdsExpected = ["51263303550", "51261381547"]
					XCTAssertEqual(photosIds, photosIdsExpected, "Expected photosId -> \(photosIdsExpected) | Received -> \(photosIds)")

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

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Success_NoResultsFound"))
			.search(tag: "tag", page: 1)
			.subscribe { event in
				switch event {
				case .success(let response):
					// total
					XCTAssertEqual(response.total, 0, "Expected response.total -> 0 | Received -> \(response.total)")
					// pages
					XCTAssertEqual(response.pages, 0, "Expected response.pages -> 0 | Received -> \(response.pages)")
					// photos
					XCTAssertTrue(response.photos.isEmpty, "Expected response.photos.isEmpty -> true | Received -> \(response.photos.isEmpty)")
					XCTAssertEqual(response.photos.count, 0, "Expected response.photos.count -> 0 | Received -> \(response.photos.count)")

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

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Fail"))
			.search(tag: "tag", page: 1)
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

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Fail_InvalidApiKey"))
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

		FlickrApiFactory.getAPI(responseData: DataHelper.data(fromJsonFile: "FlickrApiSearch_Fail_MethodNotFound"))
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
