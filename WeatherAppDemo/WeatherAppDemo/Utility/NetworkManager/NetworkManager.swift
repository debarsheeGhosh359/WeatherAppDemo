//
//  NetworkManager.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

/// Protocol for network services that can send requests and handle responses.
protocol NetworkServiceProtocol {
	/// Sends a request and calls the completion handler with the result.
	///
	/// - Parameters:
	///   - request: The request to send.
	///   - completion: A closure that takes a `Result` as a parameter and is called when the request is complete.
	func sendRequest<T: Decodable>(_ request: URLRequestProtocol, completion: @escaping (Result<T, AppError>) -> Void)
}

/// Protocol for session providers that can create data tasks.
protocol SessionProvider {
	/// Creates a data task with the given request and completion handler.
	///
	/// - Parameters:
	///   - request: The request to send.
	///   - completionHandler: A closure that takes the data, response, and error as parameters and is called when the task is complete.
	func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

/// Extension to make `URLSession` conform to `SessionProvider`.
extension URLSession: SessionProvider {}

/// A concrete implementation of `NetworkServiceProtocol` that uses a `SessionProvider` to send requests.
class NetworkManager: NetworkServiceProtocol {
	/// The session provider used to send requests.
	let session: SessionProvider

	/// Initializes the network service with a session provider.
	///
	/// - Parameter session: The session provider to use. Defaults to `URLSession.shared`.
	init(session: SessionProvider = URLSession.shared) {
		self.session = session
	}

	func sendRequest<T: Decodable>(_ request: URLRequestProtocol, completion: @escaping (Result<T, AppError>) -> Void) {
		let completionOnMain: (Result) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		do {
			let request = try request.buildRequest()
			session.dataTask(with: request) { data, response, error in
				if let error = error {
					completionOnMain(.failure(.network(.requestFailed(error))))
					return
				}

				guard let data = data else {
					completionOnMain(.failure(.network(.noData)))
					return
				}
				do {
					// First, try to decode as an error response
					if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
						completionOnMain(.failure(.network(.backend(errorResponse))))
					} else {
						// If decoding as an error fails, decode as a successful response
						let decodedObject = try JSONDecoder().decode(T.self, from: data)
						completionOnMain(.success(decodedObject))
					}
				} catch {
					completionOnMain(.failure(.network(.decodingFailed(error))))
				}
			}.resume()
		} catch {
			completionOnMain(.failure(.network(.requestFailed(error))))
		}
	}
}
