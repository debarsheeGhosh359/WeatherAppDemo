//
//  WeatherSearchViewModel.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import CoreLocation
import Foundation
import UIKit

class CityWeatherViewModel: CityWeatherViewProtocol {

	// MARK: - Public Properties
	weak var delegate: CityWeatherViewModelDelegate?
	var searchText: String = ""
	var weatherInfo: WeatherDataViewModel?

	// MARK: - Private Properties
	private let networkManager: NetworkServiceProtocol
	private var userDefaults: SavedDataProvider

	// Lazy initialization of the location manager
	private lazy var locationManager: LocationManagerProtocol = {
		let manager = LocationManager()
		manager.delegate = self
		return manager
	}()

	private lazy var geocodingService: GeocodingServiceProtocol = {
		let geocoding = GeocodingService()
		return geocoding
	}()

	required init(networkManager: NetworkServiceProtocol = NetworkManager(),
				  userDefaults: SavedDataProvider = Defaults.shared) {

		self.networkManager = networkManager
		self.userDefaults = userDefaults
		if let savedCity = userDefaults.savedCity {
			searchText = savedCity
		} else {
			initializeLocationManager()
		}
	}

	// MARK: - Public Methods
	func getWeatherData() {
		if isValidCity(searchText) {
			let searchRequest = SearchRequest.getWeatherInfo(city: searchText)
			networkManager.sendRequest(searchRequest) { [weak self] (result: Result<WeatherData, AppError>) in
				guard let self else { return }
				switch result {
					case .success(let data):
						guard let viewModel = WeatherDataViewModel(weatherData: data) else {
							self.delegate?.didFailWithError(AppError.validation(.incompleteWeatherInfo))
							return
						}
						self.userDefaults.savedCity = searchText
						self.weatherInfo = viewModel
						self.delegate?.didUpdateWeatherInfo(viewModel)
					case .failure(let error):
						self.delegate?.didFailWithError(error)
				}
			}
		} else {
			self.delegate?.didFailWithError(AppError.validation(.emptyCity))
		}
	}
}

// MARK: - Private Extension
private extension CityWeatherViewModel {

	func handleAuthorizationStatusChange(status: CLAuthorizationStatus) {
		switch status {
			case .notDetermined:
				// Request permission if it has not been determined yet
				requestLocationPermission()
			case .restricted, .denied:
				// Show alert to user to enable location services
				delegate?.promptToOpenSettings()
			case .authorizedWhenInUse, .authorizedAlways:
				// Start updating location if authorized
				startUpdatingLocation()
			@unknown default:
				break
		}
	}

	private func initializeLocationManager() {
		requestLocationPermission()
	}

	func requestLocationPermission() {
		locationManager.requestLocationPermission()
	}

	func startUpdatingLocation() {
		locationManager.startUpdatingLocation()
	}

	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
	}

	func isValidCity(_ city: String) -> Bool {
		!city.isEmpty && city.count > 2
	}
}

// MARK: - CLLocationManagerDelegate
extension CityWeatherViewModel: LocationManagerDelegate {
	func didUpdateLocation(_ manager: any LocationManagerProtocol, location: CLLocation) {
		convertCoordinatesToCity(location: location) { [weak self] result in
			guard let self else { return }
			switch result {
				case .success(let value):
					self.searchText = value
					self.getWeatherData()
				case .failure(let error):
					self.delegate?.didFailWithError(AppError.network(.requestFailed(error)))
			}
		}
	}

	func didFailWithError(_ manager: any LocationManagerProtocol, error: any Error) {
		delegate?.didFailWithError(AppError.network(.requestFailed(error)))
	}

	func didChangeAuthorization(_ manager: any LocationManagerProtocol, status: CLAuthorizationStatus) {
		handleAuthorizationStatusChange(status: status)
	}
}

// MARK: - Geocoding
extension CityWeatherViewModel {
	func convertCoordinatesToCity(location: CLLocation, completion: @escaping (Result<String, Error>) -> Void) {
		geocodingService.reverseGeocode(location: location) { result in
			switch result {
				case .success(let placemarks):
					if let city = placemarks.first?.locality {
						completion(.success(city))
					} else {
						completion(.failure(NSError(domain: "GeocodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "City not found."])))
					}
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}
}
