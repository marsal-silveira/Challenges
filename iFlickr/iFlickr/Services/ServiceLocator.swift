//
//  ServiceLocator.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation

// This is our DepencyInjection Abstraction...
// All services (app scope) must be defined here to avoid global singletons (only this one :-) )
final class ServiceLocator {

	// Singleton
	static let shared = ServiceLocator()

	private var _services: [ObjectIdentifier: Any] = [:]

	private func key<T>(for type: T.Type) -> ObjectIdentifier {
		return ObjectIdentifier(T.self)
	}

	@discardableResult
	func register<T>(_ interface: T.Type, instance: T) -> ServiceLocator {
		_services[key(for: interface.self)] = instance
		return self
	}

	func resolve<T>() -> T {
		guard let instance = _services[key(for: T.self)] as? T else {
			fatalError("No instance found for '\(String(describing: T.self))'.")
		}
		return instance
	}

	func reset() {
		_services.removeAll()
	}
}

// Wrapper to specific Services/Providers
extension ServiceLocator {
	var networkReachabilityService: NetworkReachabilityServiceProtocol { return self.resolve() as NetworkReachabilityServiceProtocol}
	var appRouter: AppRouterProtocol { return self.resolve() as AppRouterProtocol}
}
