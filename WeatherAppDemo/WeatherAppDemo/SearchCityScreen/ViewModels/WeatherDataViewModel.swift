//
//  WeatherDataViewModel.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import Foundation

struct WeatherDataViewModel {
	private let _cityName: String
	private let _weatherCondition: String
	private let _weatherIcon: String
	private let _temperature: Double
	private let _temperatureMin: Double
	private let _temperatureMax: Double
	private let _feelsLike: Double
	private let _wind: Double
	private let _visibility: Int
	private let _humidity: Int
	private let _pressure: Int

	init?(weatherData: WeatherData) {
		guard let cityName = weatherData.name,
			  let weatherCondition = weatherData.weather?.first?.main,
			  let weatherIcon = weatherData.weather?.first?.icon,
			  let temperature = weatherData.main?.temp,
			  let temperatureMin = weatherData.main?.tempMin,
			  let temperatureMax = weatherData.main?.tempMax,
			  let feelsLike = weatherData.main?.feelsLike,
			  let visibility = weatherData.visibility,
			  let humidity = weatherData.main?.humidity,
			  let pressure = weatherData.main?.pressure,
			  let wind = weatherData.wind?.speed else { return nil }

		self._cityName = cityName
		self._weatherCondition = weatherCondition
		self._weatherIcon = weatherIcon
		self._temperature = temperature
		self._temperatureMin = temperatureMin
		self._temperatureMax = temperatureMax
		self._feelsLike = feelsLike
		self._visibility = visibility
		self._humidity = humidity
		self._pressure = pressure
		self._wind = wind
	}

	var cityName: String { "\("city.Name".localized): \(_cityName)" }
	var weatherCondition: String { "\("weather.Condition".localized): \(_weatherCondition)" }
	var weatherIcon: String { _weatherIcon }
	var temperature: String { "\("temperature".localized): \(_temperature) °C" }
	var temperatureMin: String { "\("temperature.Min".localized): \(_temperatureMin) °C" }
	var temperatureMax: String { "\("temperature.Max".localized): \(_temperatureMax) °C" }
	var feelsLike: String { "\("feels.Like".localized): \(_feelsLike) °C" }
	var visibility: String { "\("visibility".localized): \(_visibility/1000) Km" }
	var humidity: String { "\("humidity".localized): \(_humidity) %" }
	var pressure: String { "\("atmospheric.Pressure".localized): \(_pressure * 100) Pa" }
	var wind: String { "\("wind.Speed".localized): \(_wind) m/s" }
	var iconUrl: String { "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png" }
    var temperatureValue: String { "\(Int(_temperature))°C" }
	var weatherConditionType: WeatherCondition { WeatherCondition(rawValue: _weatherCondition.lowercased()) ?? .clear }
}

extension WeatherDataViewModel {
	enum WeatherCondition: String {
		case thunderstorm, drizzle, rain, snow, mist, smoke, haze, fog, sand, dust , ash, squall, tornado, clear, clouds

		var imageName: String {
			self.rawValue
		}
	}
}
