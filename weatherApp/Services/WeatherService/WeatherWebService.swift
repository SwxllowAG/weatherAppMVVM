//
//  WeatherWebService.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import Foundation
import Alamofire

enum WeatherWebService {
    case byLocation(sessionManager: SessionProtocol, lat: CGFloat, lon: CGFloat)
    case byCity(sessionManager: SessionProtocol, text: String)
}

extension WeatherWebService {
    var baseURL: String { return Constants.weatherServiceURL }

    var apiKey: String { return "appid=\(Constants.weatherApiKey)" }

    var path: String {
        switch self {
        case .byLocation(_, let lat, let lon):
            return "\(baseURL)?lat=\(lat)&lon=\(lon)&units=metric&\(apiKey)"
        case .byCity(_, let text):
            return "\(baseURL)?q=\(text)&units=metric&\(apiKey)"
        }
    }

    var headers: HTTPHeaders? { return nil }

    var method: HTTPMethod { return .get }

    var parameters: [String: String]? { return nil }

    var parameterEncoding: ParameterEncoder { return JSONParameterEncoder.default }

    var dataRequest: DataRequestProtocol {
        switch self {
        case .byLocation(let sessionManager, _, _):
            return sessionManager.myRequest(path,
                                            method: method,
                                            parameters: parameters,
                                            encoder: parameterEncoding,
                                            headers: headers,
                                            interceptor: nil,
                                            requestModifier: nil)
        case .byCity(let sessionManager, _):
            return sessionManager.myRequest(path,
                                            method: method,
                                            parameters: parameters,
                                            encoder: parameterEncoding,
                                            headers: headers,
                                            interceptor: nil,
                                            requestModifier: nil)
        }
    }
}
