//
//  AlamofireNetworkReachabilityService.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

final class AlamofireNetworkReachabilityService: NetworkReachabilityServiceProtocol {

	// *************************************************
	// MARK: - Variables
	// *************************************************

	private let _reachabilityManager = NetworkReachabilityManager.default

	private var _reachabilityStatus: BehaviorRelay<NetworkReachability.Status>
	var reachabilityStatus: Observable<NetworkReachability.Status> { return _reachabilityStatus.asObservable() }

	var isReachable: Bool {
		return
			(_reachabilityStatus.value == .reachable(.ethernetOrWiFi)) ||
			(_reachabilityStatus.value == .reachable(.cellular))
	}

	// *************************************************
	// MARK: - Init
	// *************************************************

	init() {
		let status: NetworkReachability.Status = (_reachabilityManager?.isReachable ?? false) ? .reachable(.ethernetOrWiFi) : .notReachable
		_reachabilityStatus = BehaviorRelay<NetworkReachability.Status>(value: status)

		self.startReachabilityObserver()
	}

	// *************************************************
	// MARK: - Reachability
	// *************************************************

	private func startReachabilityObserver() {
		_reachabilityManager?.startListening(onUpdatePerforming: { (status) in
			self._reachabilityStatus.accept(status.wrapper())

			// [DEBUG]
			switch status {
			case .notReachable:
				Logger.log("[Reachability] The network is not reachable")
			case .unknown :
				Logger.log("[Reachability] It is unknown whether the network is reachable")
			case .reachable(.ethernetOrWiFi):
				Logger.log("[Reachability] The network is reachable over the WiFi connection")
			case .reachable(.cellular):
				Logger.log("[Reachability] The network is reachable over the Cellular connection")
			}
		})
	}

	func getReachabilityStatus() -> NetworkReachability.Status {
		return _reachabilityStatus.value
	}
}

// *************************************************
// MARK: - Wrappers from Alamofire specific types
// *************************************************

private extension NetworkReachabilityManager.NetworkReachabilityStatus {

	func wrapper() -> NetworkReachability.Status {
		switch self {
		case .unknown:
			return NetworkReachability.Status.unknown

		case .notReachable:
			return NetworkReachability.Status.notReachable

		case .reachable(let connectionType):
			return NetworkReachability.Status.reachable(connectionType.wrapper())
		}
	}
}

private extension NetworkReachabilityManager.NetworkReachabilityStatus.ConnectionType {

	func wrapper() -> NetworkReachability.ConnectionType {
		switch self {
		case .ethernetOrWiFi:
			return NetworkReachability.ConnectionType.ethernetOrWiFi
		case .cellular:
			return NetworkReachability.ConnectionType.cellular
		}
	}
}
