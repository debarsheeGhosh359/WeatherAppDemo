//
//  SearchRequest.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

enum SearchRequest {
	case getWeatherInfo(city: String)
}

extension SearchRequest: URLRequestProtocol {

	var path: String? {
		"data/2.5/weather"
	}

	var method: HTTPMethod {
		.get
	}

	var queryParams: [String : String]? {
		switch self {
		case let .getWeatherInfo(city: city):
			return [
				"q": "\(city)",
				"units": "metric",
				"appid": "79fd4865854d58cf3e358bf251db5b82"
			]
		}
	}
}
