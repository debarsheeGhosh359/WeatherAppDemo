//
//  WeatherDetailsView.swift
//  WeatherAppDemo
//
//  Created by Debarshee Ghosh on 9/5/24.
//

import SwiftUI

struct WeatherDetailsView: View {
    var weatherInfo: WeatherDataViewModel
    
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text(weatherInfo.cityName)
					Text(weatherInfo.temperature)
					Text(weatherInfo.temperatureMin)
					Text(weatherInfo.temperatureMax)
					Text(weatherInfo.feelsLike)
					Text(weatherInfo.visibility)
					Text(weatherInfo.humidity)
					Text(weatherInfo.pressure)
					Text(weatherInfo.wind)
					HStack(alignment: .center, spacing: 8) {
						Text(weatherInfo.weatherCondition)
						AsyncImage(url: URL(string: weatherInfo.iconUrl)) { image in
							image
								.resizable()
								.scaledToFit()
								.frame(width: 32, height: 32)
                                
						} placeholder: {
							// Placeholder while the image loads
							ProgressView()
								.frame(width: 32, height: 32) 
						}
						Spacer()
					}
				}
				.padding()
                
			}
		}
	}
}

#Preview {
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
	let data = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
	let object = try? JSONDecoder().decode(WeatherData.self, from: data!)
	let vm = WeatherDataViewModel(weatherData: object!)
	return WeatherDetailsView(weatherInfo: vm!)
}
