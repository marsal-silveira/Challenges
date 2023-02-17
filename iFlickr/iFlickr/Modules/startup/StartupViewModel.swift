//
//  StartupViewModel.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import Kingfisher

protocol StartupViewModelProtocol: BaseViewModelProtocol {
	func setup()
}

final class StartupViewModel: BaseViewModel, StartupViewModelProtocol {

	private let _onCompletion: VoidClosure

	init(onCompletion: @escaping VoidClosure) {
		_onCompletion = onCompletion
	}

	func setup() {
		// Configure KingFisher's caches
		// Memory Cache to 10 MB and Disk Cache to 100 MB
		let cache = ImageCache.default
		cache.memoryStorage.config.totalCostLimit = 1024 * 1024 * 10
		cache.diskStorage.config.sizeLimit = 1024 * 1024 * 100

		// Prepare the ServiceLocator (Dependency Injector) and its services
		ServiceLocator.shared.reset()
		ServiceLocator.shared
			.register(NetworkReachabilityServiceProtocol.self, instance: AlamofireNetworkReachabilityService())
			.register(AppRouterProtocol.self, instance: AppDelegate.shared.appRouter)

		// we wait more one second before continue
		DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in self?._onCompletion() }
	}
}
