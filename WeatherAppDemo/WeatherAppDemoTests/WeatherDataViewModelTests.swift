//
//  WeatherDataViewModelTests.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//
import XCTest
@testable import WeatherAppDemo

final class WeatherDataViewModelTests: XCTestCase {

	func testInitSuccess() {
		let data = try? JSONSerialization.data(withJSONObject: successData(), options: .fragmentsAllowed)
		let object = try? JSONDecoder().decode(WeatherData.self, from: data!)
		let vm = WeatherDataViewModel(weatherData: object!)
		XCTAssertNotNil(vm)
		XCTAssertEqual(vm?.cityName, "City Name: Texas")
		XCTAssertEqual(vm?.weatherCondition, "Weather Condition: Clear")
        XCTAssertEqual(vm?.weatherIcon, "02d")
        XCTAssertEqual(vm?.temperature, "Temperature: 32.97 °C")
        XCTAssertEqual(vm?.temperatureMin, "Temperature Min: 32.97 °C")
        XCTAssertEqual(vm?.temperatureMax, "Temperature Max: 34.81 °C")
        XCTAssertEqual(vm?.feelsLike, "Feels Like: 34.41 °C")
        XCTAssertEqual(vm?.visibility, "Visibility: \(10000/1000) Km")
        XCTAssertEqual(vm?.humidity, "Humidity: 43 %")
        XCTAssertEqual(vm?.pressure, "Atmospheric Pressure: \(1015 * 100) Pa")
        XCTAssertEqual(vm?.wind, "Wind Speed: 4.63 m/s")
        XCTAssertEqual(vm?.iconUrl, "https://openweathermap.org/img/wn/02d@2x.png")
	}

	func testInitFailure() {
		let data = try? JSONSerialization.data(withJSONObject: failureData(), options: .fragmentsAllowed)
		let object = try? JSONDecoder().decode(WeatherData.self, from: data!)
		let vm = WeatherDataViewModel(weatherData: object!)
		XCTAssertNil(vm)
	}
}

func successData() -> [String: Any] {
	let json = [
		"coord": [
			"lon": -99.2506,
			"lat": 31.2504
		],
		"weather": [
			[
				"id": 800,
				"main": "Clear",
				"description": "clear sky",
				"icon": "02d"
			]
		],
		"base": "stations",
		"main": [
			"temp": 32.97,
			"feels_like": 34.41,
			"temp_min": 32.97,
			"temp_max": 34.81,
			"pressure": 1015,
			"humidity": 43,
			"sea_level": 1015,
			"grnd_level": 955
		],
		"visibility": 10000,
		"wind": [
			"speed": 4.63,
			"deg": 150,
			"gust": 7.2
		],
		"clouds": [
			"all": 0
		],
		"dt": 1724524479,
		"sys": [
			"type": 1,
			"id": 3395,
			"country": "US",
			"sunrise": 1724501322,
			"sunset": 1724548209
		],
		"timezone": -18000,
		"id": 4736286,
		"name": "Texas",
		"cod": 200
	] as [String: Any]
	return json
}

func failureData() -> [String: Any] {
	let json = [
		"coord": [
			"lon": -99.2506,
			"lat": 31.2504
		],
		"weathers": [
			[
				"id": 800,
				"description": "clear sky",
			]
		],
		"base": "stations",
		"main": [
			"feels_like": 34.41,
			"temp_min": 32.97,
			"temp_max": 34.81,
			"pressure": 1015,
			"humidity": 43,
			"sea_level": 1015,
			"grnd_level": 955
		],
		"visibility": 10000,
		"wind": [
			"speed": 4.63,
			"deg": 150,
			"gust": 7.2
		],
		"clouds": [
			"all": 0
		],
		"dt": 1724524479,
		"sys": [
			"type": 1,
			"id": 3395,
			"country": "US",
			"sunrise": 1724501322,
			"sunset": 1724548209
		],
		"timezone": -18000,
		"id": 4736286,
		"name": "Texas",
		"cod": 200
	] as [String: Any]
	return json
}
