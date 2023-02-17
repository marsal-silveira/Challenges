//
//  NetworkReachabilityService.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxCocoa
import RxSwift

enum NetworkReachability {

	/// Defines the various connection types detected by reachability flags.
	///
	/// - ethernetOrWiFi: The connection type is either over Ethernet or WiFi.
	/// - wwan:  The connection type is a WWAN connection.
	enum ConnectionType: String, Equatable, Hashable {
		case ethernetOrWiFi
		case cellular

		init?(identifier: String) {
			guard let instance = ConnectionType(rawValue: identifier) else { return nil }
			self = instance
		}

		var identifier: String {
			switch self {
			case .ethernetOrWiFi:
				return "ethernetOrWiFi"

			case .cellular:
				return "cellular"
			}
		}

		func hash(into hasher: inout Hasher) {
			hasher.combine(self.identifier.hash)
		}

		static func == (lhs: ConnectionType, rhs: ConnectionType) -> Bool {
			return lhs.hashValue == rhs.hashValue
		}
	}

	/// Defines the various states of network reachability.
	///
	/// - unknown: It is unknown whether the network is reachable.
	/// - notReachable: The network is not reachable.
	/// - reachable: The network is reachable.
	enum Status: Equatable, Hashable {
		case unknown
		case notReachable
		case reachable(ConnectionType)

		var identifier: String {
			switch self {
			case .unknown:
				return "unknown"
			case .notReachable:
				return "notReachable"
			case .reachable:
				return "reachable"
			}
		}

		var isReachable: Bool {
			switch self {
			case .reachable:
				return true
			default:
				return false
			}
		}

		func hash(into hasher: inout Hasher) {
			hasher.combine(self.identifier.hash)
		}

		static func == (lhs: Status, rhs: Status) -> Bool {
			return lhs.hashValue == rhs.hashValue
		}
	}
}

protocol NetworkReachabilityServiceProtocol {
	var reachabilityStatus: Observable<NetworkReachability.Status> { get }
	var isReachable: Bool { get }

	func getReachabilityStatus() -> NetworkReachability.Status
}
