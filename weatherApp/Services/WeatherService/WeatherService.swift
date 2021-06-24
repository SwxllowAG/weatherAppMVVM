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

    let sessionManager: SessionProtocol

    init(sessionManager: SessionProtocol? = nil) {
        if let sessionManager = sessionManager {
            self.sessionManager = sessionManager
        } else {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 30
            self.sessionManager = Session(configuration: configuration)
        }
    }

    func obtainWeatherByCoordinates(lat: CGFloat, lon: CGFloat, completion: @escaping (WeatherData?, String?) -> Void) {
        _ = WeatherWebService
            .byLocation(sessionManager: sessionManager, lat: lat, lon: lon)
            .dataRequest
            .responseJSON(queue: .main,
                          dataPreprocessor: JSONResponseSerializer.defaultDataPreprocessor,
                          emptyResponseCodes: JSONResponseSerializer.defaultEmptyResponseCodes,
                          emptyRequestMethods: JSONResponseSerializer.defaultEmptyRequestMethods,
                          options: .allowFragments) { response in
            switch response.result {
            case .success(_):
                guard let encoded = response.data else {
                    DispatchQueue.main.async { completion(nil, "Empty response data") }
                    return
                }
                guard let decoded = try? JSONDecoder().decode(WeatherData.self, from: encoded) else {
                    DispatchQueue.main.async { completion(nil, "Unrecognizable data") }
                    return
                }
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
        _ = WeatherWebService
            .byCity(sessionManager: sessionManager, text: text)
            .dataRequest
            .responseJSON(queue: .main,
                          dataPreprocessor: JSONResponseSerializer.defaultDataPreprocessor,
                          emptyResponseCodes: JSONResponseSerializer.defaultEmptyResponseCodes,
                          emptyRequestMethods: JSONResponseSerializer.defaultEmptyRequestMethods,
                          options: .allowFragments) { response in
            switch response.result {
            case .success(_):
                guard let encoded = response.data else {
                    DispatchQueue.main.async { completion(nil, "Empty response data") }
                    return
                }
                guard let decoded = try? JSONDecoder().decode(WeatherData.self, from: encoded) else {
                    DispatchQueue.main.async { completion(nil, "Unrecognizable data") }
                    return
                }
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
