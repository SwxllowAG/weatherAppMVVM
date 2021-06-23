//
//  SearchCityViewModel.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit
import CoreLocation

protocol SearchCityViewModelDelegate: AnyObject {
    func didReceiveLocation(lat: CGFloat, lon: CGFloat)
    func presentError(title: String, _ errorDescription: String)
    func presentView(_ vc: UIViewController)
    func showLoader()
    func hideLoader(completion: @escaping () -> Void)
}

class SearchCityViewModel: NSObject {
    
    weak var delegate: SearchCityViewModelDelegate?
    
    private var locationManager = CLLocationManager()
    
    var lastLocation: CLLocationCoordinate2D?
    var needsToSaveLocation = false
    var shouldSearchByLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func obtainCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func requestWeatherData(text: String?) {
        guard (text != nil && !text!.isEmpty) || lastLocation != nil else { return }
        delegate?.showLoader()
        let completion: (WeatherData?, String?) -> Void = { [weak self] weatherData, error in
            self?.delegate?.hideLoader(completion: {
                if let errorString = error {
                    self?.delegate?.presentError(title: errorString, "")
                } else if let weather = weatherData {
                    self?.presentWeatherData(weather)
                }
            })
        }
        if let lastLocation = lastLocation, shouldSearchByLocation {
            WeatherService.shared.obtainWeatherByCoordinates(lat: CGFloat(lastLocation.latitude),
                                                             lon: CGFloat(lastLocation.longitude),
                                                             completion: completion)
        } else {
            WeatherService.shared.obtainWeatherByCityName(text: text!, completion: completion)
        }
    }
    
    private func presentWeatherData(_ weatherData: WeatherData) {
        let weatherModule = CurrentWeatherModuleAssembler(weather: weatherData)
        delegate?.presentView(weatherModule.vc)
    }
}

// MARK: - CLLocationManagerDelegate

extension SearchCityViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard needsToSaveLocation else { return }
        if let location = locations.first {
            lastLocation = location.coordinate
            delegate?.didReceiveLocation(lat: CGFloat(location.coordinate.latitude), lon: CGFloat(location.coordinate.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.presentError(title: "Couldn't receive location", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        obtainCurrentLocation()
    }
}
