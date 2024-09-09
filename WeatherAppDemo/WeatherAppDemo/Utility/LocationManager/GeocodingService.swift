//
//  GeocodingService.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import CoreLocation

protocol GeocodingServiceProtocol {
	func reverseGeocode(location: CLLocation, completion: @escaping (Result<[CLPlacemark], Error>) -> Void)
	func geocode(address: String, completion: @escaping (Result<[CLLocation], Error>) -> Void)
}

final class GeocodingService: GeocodingServiceProtocol {
	private let geocoder = CLGeocoder()

	func reverseGeocode(location: CLLocation, completion: @escaping (Result<[CLPlacemark], Error>) -> Void) {
		geocoder.reverseGeocodeLocation(location) { placemarks, error in
			if let error = error {
				completion(.failure(error))
			} else if let placemarks = placemarks {
				completion(.success(placemarks))
			}
		}
	}

	func geocode(address: String, completion: @escaping (Result<[CLLocation], Error>) -> Void) {
		geocoder.geocodeAddressString(address) { placemarks, error in
			if let error = error {
				completion(.failure(error))
			} else if let placemarks = placemarks {
				let locations = placemarks.compactMap({ $0.location })
				completion(.success(locations))
			}
		}
	}
}
