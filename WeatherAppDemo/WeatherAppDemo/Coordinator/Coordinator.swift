//
//  Coordinator.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import UIKit

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
		let cityWeatherDetailsViewController = WeatherDetailsViewController.init(viewModel: viewModel,
																				 coordinator: self)
		navigationController.pushViewController(cityWeatherDetailsViewController, animated: true)
	}
}
