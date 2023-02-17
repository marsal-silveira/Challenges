//
//  Alfredo.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import Moya
import RxSwift

/// Alfredo is our network request executor (Moya implementation).
struct Alfredo {

	// *************************************************
	// MARK: - Static/Default Plugins
	// *************************************************

	private static var plugins: [PluginType] {
		var result: [PluginType] = []
		#if DEBUG
		result.append(NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose)))
		#endif

		return result
	}

	// *************************************************
	// MARK: - Properties
	// *************************************************

	private let _provider: MoyaProvider<MultiTarget>

	/// expose the request response as a Rx event
	let rx: Rx

	// *************************************************
	// MARK: - Lifecycle
	// *************************************************

	init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>(plugins: plugins)) {
		_provider = provider
		rx = Rx(provider: _provider)
	}

	// *************************************************
	// MARK: - Request
	// *************************************************

	@discardableResult
	func request(target: TargetType, completion: @escaping Completion) -> Cancellable {
		return _provider.request(MultiTarget(target), completion: completion)
	}
}

// *************************************************
// MARK: - Reactive (Rx)
// *************************************************

extension Alfredo {
	struct Rx {
		private let _provider: MoyaProvider<MultiTarget>

		init(provider: MoyaProvider<MultiTarget>) {
			_provider = provider
		}

		func request(target: TargetType) -> Single<Moya.Response> {
			return _provider.rx.request(MultiTarget(target))
		}
	}
}

// *************************************************
// MARK: - Timeout
// *************************************************

extension Alfredo {
	enum Timeout {
		static let short = RxTimeInterval.seconds(30) // 30sec
		static let medium = RxTimeInterval.seconds(60) // 1min
		static let long = RxTimeInterval.seconds(120) // 2min
	}
}

// *************************************************
// MARK: - Status Code
// *************************************************

extension Alfredo {
	enum HttpStatusCodeType: Equatable {

		/// No one.
		case none
		/// Success codes (only 2xx).
		case successCodes
		/// Custom codes.
		case customCodes([Int])

		/// The list of HTTP status code as array
		func asArray() -> [Int] {
			switch self {
			case .successCodes:
				return Array(200..<300)
			case .customCodes(let codes):
				return codes
			case .none:
				return []
			}
		}

		// Equatable
		static func == (lhs: Alfredo.HttpStatusCodeType, rhs: Alfredo.HttpStatusCodeType) -> Bool {
			switch (lhs, rhs) {
			case (.none, .none),
				 (.successCodes, .successCodes):
				return true
			case (.customCodes(let codes1), .customCodes(let codes2)):
				return codes1 == codes2
			default:
				return false
			}
		}
	}
}

// *************************************************
// MARK: - Utils
// *************************************************

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

	private func internalValidateStatusCodes(_ codes: [Int]) -> Single<Moya.Response> {
		return flatMap({ response -> Single<Moya.Response> in
			guard codes.contains(response.statusCode) else { return Single.error(MoyaError.statusCode(response)) }
			return Single.just(response)
		})
	}

	func validateStatusCode(_ statusCodeType: Alfredo.HttpStatusCodeType) -> Single<Moya.Response> {
		return self.internalValidateStatusCodes(statusCodeType.asArray())
	}

	func validateStatusCode(_ statusCodes: Alfredo.HttpStatusCodeType...) -> Single<Moya.Response> {
		let finalCodes = statusCodes.flatMap { (codes) -> [Int] in return codes.asArray() }
		return self.internalValidateStatusCodes(finalCodes)
	}

	/// convert response to JSON
	func toJSON() -> Single<JSON> {
		return flatMap({ response -> Single<JSON> in
			let json: JSON
			do {
				json = try JSONSerialization.jsonObject(with: response.data, options: []) as? JSON ?? [:]
			} catch {
				return Single.error(DecodingError.wrongFormat)
			}
			return Single.just(json)
		})
	}

	func map<T: Decodable>(_ handleBlock: @escaping (Moya.Response) throws -> T) -> Single<T> {
		return flatMap { .just(try handleBlock($0)) }
	}

	func mapObject<T: Decodable>(_ resultType: T.Type) -> Single<T> {
		return flatMap { .just(try JSONDecoder().decode(T.self, from: $0.data)) }
	}

	func mapArray<T: Decodable>(_ resultType: T.Type) -> Single<[T]> {
		return flatMap { .just(try JSONDecoder().decode([T].self, from: $0.data)) }
	}
}
