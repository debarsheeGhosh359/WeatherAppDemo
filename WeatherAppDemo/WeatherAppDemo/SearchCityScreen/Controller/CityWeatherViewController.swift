//
//  CityWeatherViewController.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import UIKit
import SwiftUI

class CityWeatherViewController: UIViewController {

	private lazy var searchBar: UISearchBar = {
		let searchBar = UISearchBar.viewWithoutARMask()
		searchBar.placeholder = "search.City".localized
		searchBar.delegate = self
		return searchBar
    }()

	// MARK: - Private views
	private lazy var cityLabel: UILabel = {
		let label = UILabel.viewWithoutARMask()
		label.textColor = .black
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.numberOfLines = 1
		label.setContentHuggingPriority(.required, for: .horizontal)
		return label
	}()

	private lazy var weatherStateLabel: UILabel = {
		let label = UILabel.viewWithoutARMask()
		label.textColor = .black
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.numberOfLines = 1
		label.setContentHuggingPriority(.required, for: .horizontal)
		return label
	}()

	private lazy var temperatureLabel: UILabel = {
		let label = UILabel.viewWithoutARMask()
		label.textColor = .black
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.numberOfLines = 1
		label.setContentHuggingPriority(.required, for: .horizontal)
		return label
	}()

	private lazy var humidityLabel: UILabel = {
		let label = UILabel.viewWithoutARMask()
		label.textColor = .black
		label.font = .systemFont(ofSize: 17, weight: .semibold)
		label.numberOfLines = 1
		label.setContentHuggingPriority(.required, for: .horizontal)
		return label
	}()

	private lazy var showMoreButton: UIButton = {
		let button = UIButton.viewWithoutARMask()
		button.layer.cornerRadius = 5
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 1
		button.isEnabled = false
		button.setTitleColor(.black, for: .normal)
		button.setTitle("show.More".localized, for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
		button.addTarget(self, action: #selector(showMore), for: .touchUpInside)
		return button
	}()

	private lazy var stackViewTextContainer = {
		let stackView = UIStackView.verticalWith(alignment: .leading, spacing: 16)
		stackView.addArrangedSubViews(cityLabel, weatherStateLabel, humidityLabel, temperatureLabel)
		return stackView
	}()

	private let viewModel: CityWeatherViewProtocol
	private weak var coordinator: AppCoordinator?

	init(viewModel: CityWeatherViewProtocol = CityWeatherViewModel(), coordinator: AppCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.setUpView()
		viewModel.delegate = self
        guard let savedCity = Defaults.shared.savedCity else {
            return
        }
        if !savedCity.isEmpty {
            viewModel.getWeatherData()
        }
    }

	private func setUpView() {
		self.view.backgroundColor = .white
		self.title = "search.City".localized

		view.addSubview(searchBar)
		view.addSubview(stackViewTextContainer)
		view.addSubview(showMoreButton)

		NSLayoutConstraint.activate([
			// Search Bar
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.trailingAnchor, constant: 20),

			// Vertical StackView
            stackViewTextContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
			stackViewTextContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30),
            view.trailingAnchor.constraint(equalTo: stackViewTextContainer.safeAreaLayoutGuide.trailingAnchor, constant: 20),

			// Show More Button
			showMoreButton.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
			showMoreButton.topAnchor.constraint(equalTo: stackViewTextContainer.bottomAnchor, constant: 32),
            showMoreButton.trailingAnchor.constraint(equalTo: searchBar.safeAreaLayoutGuide.trailingAnchor),
			view.bottomAnchor.constraint(greaterThanOrEqualTo: showMoreButton.bottomAnchor, constant: 20),
		])
	}

	private func updateWeatherInformation(_ weatherData: WeatherDataViewModel) {
		cityLabel.text = weatherData.cityName
		weatherStateLabel.text = weatherData.weatherCondition
		temperatureLabel.text = weatherData.temperature
		humidityLabel.text = weatherData.humidity
		showMoreButton.isEnabled = true
	}

	private func showAlert(_ error: AppError) {

		let alert = UIAlertController(title: error.title,
									  message: error.description,
									  preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: nil))
		present(alert, animated: true)
	}

	private func openAppSettings() {
		if let url = URL(string: UIApplication.openSettingsURLString) {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
	}

	@objc
	private func showMore() {
		guard let weatherInfo = viewModel.weatherInfo else { return }
		coordinator?.goToWeatherDetailsPage(viewModel: weatherInfo)
	}
}

extension CityWeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.searchText = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
		viewModel.getWeatherData()
    }
}

extension CityWeatherViewController: CityWeatherViewModelDelegate {

	func didUpdateWeatherInfo(_ weatherData: WeatherDataViewModel) {
		updateWeatherInformation(weatherData)
	}

	func didFailWithError(_ error: AppError) {
		showAlert(error)
	}

	func promptToOpenSettings() {
		let alert = UIAlertController(title: "location.Disabled".localized,
									  message: "enable.location.Message".localized,
									  preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "open.Settings".localized, style: .default) { _ in
			self.openAppSettings()
		})
		present(alert, animated: true, completion: nil)
	}
}
