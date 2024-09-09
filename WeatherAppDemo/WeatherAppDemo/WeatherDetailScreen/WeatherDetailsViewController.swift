//
//  WeatherDetailsViewController.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import UIKit
import SwiftUI

class WeatherDetailsViewController: UIViewController {
	var viewModel: WeatherDataViewModel
	weak var coordinator: AppCoordinator?

	init(viewModel: WeatherDataViewModel,
		 coordinator: AppCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = NSLocalizedString("Weather Details", comment: "")
		// Create the SwiftUI view
		let swiftUIView = WeatherDetailsView(weatherInfo: viewModel)
		// Embed the SwiftUI view in a UIHostingController
		let hostingController = UIHostingController(rootView: swiftUIView)
		// Add the hostingController as a child of the current UIViewController
		addChild(hostingController)
		// Add the SwiftUI view to the view hierarchy
		view.addSubview(hostingController.view)
		// Set constraints or frame for the SwiftUI view
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
			hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		// Notify the hosting controller that it has been moved to the parent view controller
		hostingController.didMove(toParent: self)
	}
}
