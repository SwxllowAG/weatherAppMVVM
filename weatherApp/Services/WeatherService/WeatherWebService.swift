//
//  WeatherWebService.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import Foundation
import Alamofire

enum WeatherWebService {
    case byLocation(lat: CGFloat, Lon: CGFloat)
    case byCity(text: String)
    
    var baseURL: String { return Constants.weatherServiceURL }
    
    var apiKey: String { return "appid=\(Constants.weatherApiKey)" }
    
    var path: String {
        switch self {
        case .byLocation(let lat, let lon):
            return "\(baseURL)?lat=\(lat)&lon=\(lon)&units=metric&\(apiKey)"
        case .byCity(let text):
            return "\(baseURL)?q=\(text)&units=metric&\(apiKey)"
        }
    }
    
    var headers: HTTPHeaders? { return nil }
    
    var method: HTTPMethod { return .get }
    
    var parameters: [String: String]? { return nil }
    
    var parameterEncoding: ParameterEncoder { return JSONParameterEncoder.default }
    
    var dataRequest: DataRequest {
        return AF.request(path, method: method, parameters: parameters, encoder: parameterEncoding, headers: headers)
    }
}
