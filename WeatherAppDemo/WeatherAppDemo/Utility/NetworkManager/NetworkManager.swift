//
//  NetworkManager.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation


protocol NetworkServiceProtocol {

	func sendRequest<T: Decodable>(_ request: URLRequestProtocol, completion: @escaping (Result<T, AppError>) -> Void)
}


protocol SessionProvider {
	func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}


extension URLSession: SessionProvider {}


class NetworkManager: NetworkServiceProtocol {

	let session: SessionProvider

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
					if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
						completionOnMain(.failure(.network(.backend(errorResponse))))
					} else {
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
