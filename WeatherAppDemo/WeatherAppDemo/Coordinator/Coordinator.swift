//
//  Coordinator.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import SwiftUI

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {

	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		goToSearchCityPage()
	}

	func goToSearchCityPage() {
		let cityWeatherViewController = CityWeatherViewController(coordinator: self)
		navigationController.pushViewController(cityWeatherViewController, animated: true)
	}

	func goToWeatherDetailsPage(viewModel: WeatherDataViewModel) {
		let weatherDetailView = WeatherDetailsView(weatherInfo: viewModel)
		goToSwiftUIView(swiftUIView: weatherDetailView)
	}

	func goToSwiftUIView<T: View>(swiftUIView: T) {
		let hostingController = UIHostingController(rootView: swiftUIView)
		navigationController.navigationBar.tintColor = .black
		navigationController.pushViewController(hostingController, animated: true)
	}
}
