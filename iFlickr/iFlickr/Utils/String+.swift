//
//  String+.swift
//  iFlickr
//
//  Created by Marsal Silveira.
//

import Foundation

extension String {
	var isNotEmpty: Bool {
		let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		return trimmed.isEmpty == false
	}
}
