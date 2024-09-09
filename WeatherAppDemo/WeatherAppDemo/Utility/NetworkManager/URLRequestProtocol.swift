//
//  EndPointType.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

/// Protocol defining a builder for URL requests.
protocol URLRequestProtocol {
	/// The base URL as a string.
	var baseURL: String { get }
	/// The optional path to be appended to the base URL.
	var path: String? { get }
	/// The HTTP method to be used (e.g., "GET", "POST").
	var method: HTTPMethod { get }
	/// Optional headers to be included in the request.
	var headers: [String: String]? { get }
	/// Optional query parameters to be included in the URL.
	var queryParams: [String: String]? { get }
	/// Optional body parameters to be included in the request body.
	var bodyParams: [String: Any]? { get }

	/// Builds and returns a `URLRequest` based on the properties set in the builder.
	/// - Throws: `NetworkError.invalidURL` if the URL could not be constructed.
	/// - Returns: A configured `URLRequest`.
	func buildRequest() throws -> URLRequest
}

extension URLRequestProtocol {

	var baseURL: String { "https://api.openweathermap.org/" }
	var headers: [String: String]? { nil }
	var bodyParams: [String: Any]? { nil }

	/// Helper method to encode parameters for URL query.
	/// - Parameter parameters: Dictionary of query parameters.
	/// - Returns: Percent encoded query string.
	private func encodeParameters(parameters: [String: String]) -> String {
		var components = URLComponents()
		components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
		return components.percentEncodedQuery ?? ""
	}

	func buildRequest() throws -> URLRequest {
		guard var urlComponents = URLComponents(string: baseURL) else {
			throw AppError.NetworkError.invalidURL
		}

		// Add path
		if let path = path {
			urlComponents.path = urlComponents.path.appending(path)
		}

		// Add query parameters
		if let queryParams = queryParams {
			let encodedQuery = encodeParameters(parameters: queryParams)
			urlComponents.query = encodedQuery
		}

		guard let url = urlComponents.url else {
			throw AppError.NetworkError.invalidURL
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		// Add headers
		if let headers = headers {
			for (key, value) in headers {
				request.addValue(value, forHTTPHeaderField: key)
			}
		}

		// Add body parameters
		if let bodyParams = bodyParams {
			request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		return request
	}
}
