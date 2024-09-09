//
//  MockNetworkManager.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation
@testable import WeatherAppDemo

class MockNetworkManager: NetworkServiceProtocol {
    
    var mockData = successData()
    var validRequest = true

	func sendRequest<T>(_ request: URLRequestProtocol, completion: @escaping (Result<T, AppError>) -> Void) where T : Decodable {
        if validRequest {
            let mockData = mockData
            let data = try! JSONSerialization.data(withJSONObject: mockData)
            let object = try! JSONDecoder().decode(T.self, from: data)
            completion(.success(object))
        } else {
            completion(.failure(AppError.network(.invalidURL)))
        }
	}
}

class MockDefaults: SavedDataProvider {
	var savedCity: String? = "Austin"
}

class MockCityWeatherViewModelDelegate: CityWeatherViewModelDelegate {
	var weatherInfo: WeatherDataViewModel?
	var error: AppError?
	var openSettingsExecuted: Bool = false

	func didUpdateWeatherInfo(_ weatherData: WeatherAppDemo.WeatherDataViewModel) {
		weatherInfo = weatherData
	}
	
	func didFailWithError(_ error: WeatherAppDemo.AppError) {
		self.error = error
	}
	
	func promptToOpenSettings() {
		openSettingsExecuted = true
	}
}
