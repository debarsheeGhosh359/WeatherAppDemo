//
//  UIView+Extension.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import UIKit

extension UIView {
	public static func viewWithoutARMask() -> Self {
		let view = Self()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
}

extension UIStackView {

	static func stackViewWith(
		axis: NSLayoutConstraint.Axis = .vertical,
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .fill,
		spacing: CGFloat = 0
	) -> UIStackView {
		let stackView = UIStackView.viewWithoutARMask()
		stackView.axis = axis
		stackView.distribution = distribution
		stackView.spacing = spacing
		stackView.alignment = alignment
		return stackView
	}

	static func verticalWith(
		distribution: UIStackView.Distribution = .fill,
		alignment: UIStackView.Alignment = .fill,
		spacing: CGFloat = 0
	) -> UIStackView {
		UIStackView.stackViewWith(
			axis: .vertical,
			distribution: distribution,
			alignment: alignment,
			spacing: spacing
		)
	}


	func addArrangedSubViews(_ views: UIView...) {
		views.forEach { self.addArrangedSubview($0) }
	}
}
