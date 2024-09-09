//
//  MockLocationManager.swift
//  WeatherAppDemoTests
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation
@testable import WeatherAppDemo

class MockLocationManager: LocationManagerProtocol {
    var delegate: LocationManagerDelegate?

	var isLocationPermissionExecuted = false
	var shouldStartUpdatingLocation = false
	var shouldStopUpdatingLocation = false

    func requestLocationPermission() {
		isLocationPermissionExecuted = true
    }
    
    func startUpdatingLocation() {
		shouldStartUpdatingLocation = true
    }
    
    func stopUpdatingLocation() {
		shouldStopUpdatingLocation = true
    }
}
