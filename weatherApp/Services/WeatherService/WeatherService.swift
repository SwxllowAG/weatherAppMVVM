//
//  WeatherService.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import Foundation
import Alamofire

class WeatherService {
    
    static var shared = WeatherService()
    
    func obtainWeatherByCoordinates(lat: CGFloat, lon: CGFloat, completion: @escaping (WeatherData?, String?) -> Void) {
        WeatherWebService.byLocation(lat: lat, Lon: lon).dataRequest.responseJSON { response in
            switch response.result {
            case .success(_):
                guard let encoded = response.data else { DispatchQueue.main.async { completion(nil, "Empty response data") }; return }
                guard let decoded = try? JSONDecoder().decode(WeatherData.self, from: encoded) else { DispatchQueue.main.async { completion(nil, "Unrecognizable data") }; return }
                DispatchQueue.main.async {
                    completion(decoded, nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func obtainWeatherByCityName(text: String, completion: @escaping (WeatherData?, String?) -> Void) {
        WeatherWebService.byCity(text: text).dataRequest.responseJSON { response in
            switch response.result {
            case .success(_):
                guard let encoded = response.data else { DispatchQueue.main.async { completion(nil, "Empty response data") }; return }
                guard let decoded = try? JSONDecoder().decode(WeatherData.self, from: encoded) else { DispatchQueue.main.async { completion(nil, "Unrecognizable data") }; return }
                DispatchQueue.main.async {
                    completion(decoded, nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
}
