//
//  UserDefaultHandler.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

@propertyWrapper
struct UserDefaultHandler<Value> {
	let key: String
	let value: Value
	var storage: UserDefaults = .standard

	var wrappedValue: Value {
		get {
			storage.value(forKey: key) as? Value ?? value
		}
		set {
			storage.setValue(value, forKey: key)
		}
	}
}

@propertyWrapper
struct OptionalDefaultHandler<Value: Codable> {
	let key: String

	init(key: String) {
		self.key = key
	}

	var wrappedValue: Value? {
		get {
			guard let data = UserDefaults.standard.data(forKey: key),
				  let object = try? JSONDecoder().decode(Value.self, from: data) else { return nil }
			return object
		}
		set {
			if newValue == nil {
				UserDefaults.standard.removeObject(forKey: key)
			} else {
				guard let data = try? JSONEncoder().encode(newValue) else { return }
				UserDefaults.standard.set(data, forKey: key)
			}
			UserDefaults.standard.synchronize()
		}
	}
}

extension UserDefaultHandler where Value: ExpressibleByNilLiteral {
	init(key: String, storage: UserDefaults = .standard) {
		self.init(key: key, value: nil, storage: storage)
	}
}

class Defaults {
	static var shared = Defaults()

	private init() {}

	@OptionalDefaultHandler(key: "SavedCity")
	var savedCity: String?
}
