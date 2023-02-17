//
//  BaseViewModel.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModelProtocol: AnyObject {

}

class BaseViewModel: BaseViewModelProtocol {

	// ************************************************
	// MARK: - Lifecycle
	// ************************************************

	init() {
		Logger.debug("🆕 ---> \(String(describing: type(of: self)))")
	}

	deinit {
		Logger.debug("☠️ ---> \(String(describing: type(of: self)))")
	}
}
