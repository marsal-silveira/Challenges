//
//  Logger.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation
import os

/// Just a wrapper over Apple's "os_log".
/// A `Logger` is the central type in `Logger` ecosystem.
/// Its central function is to emit log messages using one of the methods corresponding to a log level.
///
/// The most basic usage of a `Logger` is
///
///     Logger.info("Hello World!")
///
enum Logger {
	typealias Category = OSLog
	typealias Level = OSLogType

	static func log(
		_ message: String,
		category: Logger.Category = .default,
		level: Logger.Level = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		#if DEBUG
			let prefix = "[\(URL(fileURLWithPath: file).lastPathComponent)] [\(function)] [\(line)]"
			let finalMessage = "\(prefix) \(message)"

			os_log("%@", log: category, type: level, finalMessage)
		#endif
	}
}

extension Logger {

	static func `default`(
		_ message: String,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(message, category: category, level: .default, file: file, function: function, line: line)
	}

	static func info(
		_ message: String,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(message, category: category, level: .info, file: file, function: function, line: line)
	}

	static func debug(
		_ message: String,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(message, category: category, level: .debug, file: file, function: function, line: line)
	}

	static func error(
		_ message: String,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(message, category: category, level: .error, file: file, function: function, line: line)
	}

	static func error(
		_ error: Error,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(error.localizedDescription, category: category, level: .error, file: file, function: function, line: line)
	}

	static func fault(
		_ message: String,
		category: Logger.Category = .default,
		file: String = #file, function: String = #function, line: Int = #line) {

		self.log(message, category: category, level: .fault, file: file, function: function, line: line)
	}
}
