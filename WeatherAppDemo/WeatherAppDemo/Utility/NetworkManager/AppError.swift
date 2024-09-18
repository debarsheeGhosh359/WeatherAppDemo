//
//  AppError.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Decodable {
	let cod: String?
	let message: String?
}

enum AppError: Error {

	enum Validation: Error {
		case emptyCity
		case incompleteWeatherInfo
	}

	/// Enum representing the possible network errors.
	enum NetworkError: Error {
		/// Indicates an invalid URL error.
		case invalidURL
		/// Indicates a request failure with an associated error.
		case requestFailed(Error)
		/// Indicates a decoding failure with an associated error.
		case decodingFailed(Error)
		/// Indicates a server error with an associated status code.
		case serverError(Int)
		/// Indicates no data in the response.
		case noData
		/// Indicates a backend error with status code 200.
		case backend(ErrorResponse)
	}

	case validation(Validation)
	case network(NetworkError)
}

extension AppError {
	var title: String {
		switch self {
			case .validation(let value):
				switch value {
					case .emptyCity:
						return NSLocalizedString("Name too short!", comment: "")
					case .incompleteWeatherInfo:
						return NSLocalizedString("Data Incomplete!", comment: "")
				}
			case .network:
				return "Error!"
		}
	}

	var description: String {
		switch self {
			case .validation(let value):
				switch value {
					case .emptyCity:
						return NSLocalizedString("Provide a valid city name.", comment: "")
					case .incompleteWeatherInfo:
						return NSLocalizedString("Weather data is not sufficient for this city/location.", comment: "")
				}
			case .network(let value):
				switch value {
					case .backend(let response):
						return response.message ?? NSLocalizedString("Something went worng. Please try again later!!!", comment: "")
					default:
						return value.localizedDescription
				}
		}
	}
}
