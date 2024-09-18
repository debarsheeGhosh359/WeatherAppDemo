//
//  LocationManager.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import CoreLocation
import Foundation

protocol LocationManagerProtocol {
	var delegate: LocationManagerDelegate? { get set }
	func requestLocationPermission()
	func startUpdatingLocation()
	func stopUpdatingLocation()
}

protocol LocationManagerDelegate: AnyObject {
	func didUpdateLocation(_ manager: LocationManagerProtocol, location: CLLocation)
	func didFailWithError(_ manager: LocationManagerProtocol, error: Error)
	func didChangeAuthorization(_ manager: LocationManagerProtocol, status: CLAuthorizationStatus)
}

final class LocationManager: NSObject, LocationManagerProtocol {
	private let locationManager: CLLocationManager
	weak var delegate: LocationManagerDelegate?

	// Variables to store the most recent location and a debounce timer
	private var lastKnownLocation: CLLocation?
	private var debounceTimer: Timer?

	// Configuration for accuracy and time
	private let desiredAccuracyThreshold: CLLocationAccuracy = 50 // Meters
	private let maxLocationAge: TimeInterval = 10 // Seconds

	init(locationManager: CLLocationManager = CLLocationManager()) {
		self.locationManager = locationManager
		super.init()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.distanceFilter = 10 // Update when user moves 10 meters
	}

	func requestLocationPermission() {
		locationManager.requestWhenInUseAuthorization()
	}

	func startUpdatingLocation() {
		locationManager.startUpdatingLocation()
	}

	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
		debounceTimer?.invalidate()
	}

	private func isLocationValid(_ location: CLLocation) -> Bool {
		let isAccurateEnough = location.horizontalAccuracy <= desiredAccuracyThreshold
		let isFreshEnough = abs(location.timestamp.timeIntervalSinceNow) <= maxLocationAge
		return isAccurateEnough && isFreshEnough
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last, isLocationValid(location) else { return }

		// Update the last known location
		lastKnownLocation = location

		// Invalidate the previous timer and start a new one
		debounceTimer?.invalidate()
		debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
			self?.sendLocationUpdate(location)
		}
	}

	private func sendLocationUpdate(_ location: CLLocation) {
		guard let lastLocation = lastKnownLocation else { return }

		// Further validation (if required) before updating the delegate
		if isLocationValid(lastLocation) {
			delegate?.didUpdateLocation(self, location: lastLocation)
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate?.didFailWithError(self, error: error)
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		delegate?.didChangeAuthorization(self, status: status)
	}
}
