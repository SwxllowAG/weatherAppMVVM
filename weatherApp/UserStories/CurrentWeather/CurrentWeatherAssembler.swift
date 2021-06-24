//
//  CurrentWeatherAssembler.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

class CurrentWeatherModuleAssembler: ModuleAssembler {
    typealias ViewController = CurrentWeatherViewController

    var view: ViewController

    init(weather: WeatherData) {
        view = CurrentWeatherViewController()
        view.weatherData = weather
        setupViewModel()
    }

    internal func setupViewModel() { }
}
