//
//  String+Extension.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

// Localizable
extension String {

	public init(localizationKey key: String) {
		self.init()
		self = localizationValue(withKey: key)
	}

	public init(localizationKey key: String, params: [String: String]) {
		self = .init(localizationKey: key)
		params.forEach { key, value in
			self = self.replacingOccurrences(of: "__\(key)__", with: value)
		}
	}

	public var localized: String {
		String(localizationKey: self)
	}

	public func localizationValue(
		withKey key: String,
		bundle: Bundle = .main,
		tableName: String? = nil
	) -> String {
		bundle.localizedString(forKey: key, value: "**\(self)**", table: tableName)
	}
}
