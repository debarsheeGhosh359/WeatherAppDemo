//
//  CityWeatherViewModelTests.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import XCTest
import CoreLocation
@testable import WeatherAppDemo

final class CityWeatherViewModelTests: XCTestCase {
	var mockManager: MockNetworkManager!
	var mockDefaults: MockDefaults!
	var mockDelegate: MockCityWeatherViewModelDelegate!
	var mockLocationManager: MockLocationManager!

    override func setUpWithError() throws {
		try super.setUpWithError()
		mockManager = MockNetworkManager()
		mockDefaults = MockDefaults()
		mockDelegate = MockCityWeatherViewModelDelegate()
		mockLocationManager = MockLocationManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		mockManager = nil
		mockDefaults = nil
		mockDelegate = nil
		mockLocationManager = nil
		try super.tearDownWithError()
    }

	func testGetWeatherData() {
		let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
		vm.delegate = mockDelegate
		vm.getWeatherData()
		XCTAssertNotNil(mockDelegate.weatherInfo)
		XCTAssertEqual(mockDelegate.weatherInfo?.cityName, "City Name: Texas")
		XCTAssertEqual(mockDelegate.weatherInfo?.weatherCondition, "Weather Condition: Clear")
        XCTAssertEqual(mockDelegate.weatherInfo?.weatherIcon, "02d")
        XCTAssertEqual(mockDelegate.weatherInfo?.temperature, "Temperature: 32.97 °C")
        XCTAssertEqual(mockDelegate.weatherInfo?.temperatureMin, "Temperature Min: 32.97 °C")
        XCTAssertEqual(mockDelegate.weatherInfo?.temperatureMax, "Temperature Max: 34.81 °C")
        XCTAssertEqual(mockDelegate.weatherInfo?.feelsLike, "Feels Like: 34.41 °C")
        XCTAssertEqual(mockDelegate.weatherInfo?.visibility, "Visibility: \(10000/1000) Km")
        XCTAssertEqual(mockDelegate.weatherInfo?.humidity, "Humidity: 43 %")
        XCTAssertEqual(mockDelegate.weatherInfo?.pressure, "Atmospheric Pressure: \(1015 * 100) Pa")
        XCTAssertEqual(mockDelegate.weatherInfo?.wind, "Wind Speed: 4.63 m/s")
		XCTAssertNil(mockDelegate.error)
	}
    
    func testEmptyCity() {
        mockDefaults.savedCity = ""
        let mockDelegate = MockCityWeatherViewModelDelegate()
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        vm.delegate = mockDelegate
        vm.getWeatherData()
        XCTAssertNotNil(mockDelegate.didFailWithError(.validation(.emptyCity)))
    }
    
    func testIncompleteWeatherInfo() {
        mockManager.mockData = [:]
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        vm.delegate = mockDelegate
        vm.getWeatherData()
        XCTAssertNotNil(mockDelegate.didFailWithError(.validation(.incompleteWeatherInfo)))
    }
    
    func testResultFailure() {
        mockManager.validRequest = false
        let mockDelegate = MockCityWeatherViewModelDelegate()
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        vm.delegate = mockDelegate
        vm.getWeatherData()
        XCTAssertNotNil(mockDelegate.didFailWithError(.network(.invalidURL)))
    }
    
    func testLocationUpdated() {
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        let mockLocation = CLLocation(latitude: 1.2504, longitude: -99.2506)
        vm.delegate = mockDelegate
        vm.didUpdateLocation(mockLocationManager, location: mockLocation)
    }
    
    func testAuthorizationNotDetermined() {
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        let status: CLAuthorizationStatus = .notDetermined
        vm.didChangeAuthorization(mockLocationManager, status: status)
    }
    
    func testAuthorizationRestricted() {
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        let status: CLAuthorizationStatus = .notDetermined
        vm.didChangeAuthorization(mockLocationManager, status: status)
    }
    
    func testLocationFailure() {
        let vm = CityWeatherViewModel(networkManager: mockManager, userDefaults: mockDefaults)
        vm.didFailWithError(mockLocationManager, error: AppError.network(.invalidURL))
    }
    
}
