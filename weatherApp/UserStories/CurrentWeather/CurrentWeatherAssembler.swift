//
//  CurrentWeatherAssembler.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

class CurrentWeatherModuleAssembler: ModuleAssembler {
    typealias ViewController = CurrentWeatherViewController
    
    var vc: ViewController
    
    init(weather: WeatherData) {
        vc = CurrentWeatherViewController()
        vc.weatherData = weather
        setupViewModel()
    }
    
    internal func setupViewModel() {
        
    }
}
