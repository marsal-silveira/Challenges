//
//  Error.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation

// *************************************************
// MARK: - Protocol + Default Extension
// *************************************************

protocol ErrorProtocol: LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {

}

extension ErrorProtocol {
	var errorDescription: String? { return description }
	var localizedDescription: String { return description }
	var debugDescription: String { return description }
}

// *************************************************
// MARK: - General
// *************************************************

enum GeneralError: ErrorProtocol {
	case unknown

	var description: String {
		switch self {
			case .unknown:
				return Strings.errorGeneral()
		}
	}
}

// *************************************************
// MARK: - Network
// *************************************************

enum NetworkError: ErrorProtocol {
	case noConnection

	var description: String {
		switch self {
		case .noConnection:
			return Strings.errorNetworkNoConnection()
		}
	}
}

// *************************************************
// MARK: - Decoding
// *************************************************

/// An error that occurs during the decoding of a value (JSON).
enum DecodingError: ErrorProtocol {
	/// An indication that the value used to decode isn't valid
	case wrongFormat
	/// An indication that the given key doens't exist on JSON.
	case keyNotFound(key: String, entity: String)

	var description: String {
		switch self {
		case .wrongFormat:
			return Strings.errorDecondingWrongFormat()
		case .keyNotFound(let key, let entity):
			return Strings.errorDecondingKeyNotFound(key, entity)
		}
	}
}
