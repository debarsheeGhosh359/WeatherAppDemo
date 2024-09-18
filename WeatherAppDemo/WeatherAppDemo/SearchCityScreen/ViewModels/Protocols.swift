//
//  Protocols.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

protocol CityWeatherViewModelDelegate: AnyObject {
	func didUpdateWeatherInfo(_ weatherData: WeatherDataViewModel)
	func didFailWithError(_ error: AppError)
	func promptToOpenSettings()
}

protocol CityWeatherViewProtocol: AnyObject {
	var searchText: String { get set }
	var delegate: CityWeatherViewModelDelegate? { get set }
	var weatherInfo: WeatherDataViewModel? { get }

	init(networkManager: NetworkServiceProtocol,
		 userDefaults: SavedDataProvider)

	func getWeatherData()
}

protocol SavedDataProvider {
	var savedCity: String? { get set }
}
extension Defaults: SavedDataProvider {}

