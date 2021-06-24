//
//  SessionProtocol.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 24.06.2021.
//

import Foundation
import Alamofire

protocol SessionProtocol {
    func myRequest(_ convertible: URLConvertible,
                   method: HTTPMethod,
                   parameters: [String: String]?,
                   encoder: ParameterEncoder,
                   headers: HTTPHeaders?,
                   interceptor: RequestInterceptor?,
                   requestModifier: ((inout URLRequest) throws -> Void)?) -> DataRequestProtocol
}

protocol DataRequestProtocol {
    func responseJSON(queue: DispatchQueue,
                      dataPreprocessor: DataPreprocessor,
                      emptyResponseCodes: Set<Int>,
                      emptyRequestMethods: Set<HTTPMethod>,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self
}

extension Session: SessionProtocol {
    func myRequest(_ convertible: URLConvertible,
                   method: HTTPMethod = .get,
                   parameters: [String: String]? = nil,
                   encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                   headers: HTTPHeaders? = nil,
                   interceptor: RequestInterceptor? = nil,
                   requestModifier: ((inout URLRequest) throws -> Void)? = nil) -> DataRequestProtocol {
        return request(convertible,
                       method: method,
                       parameters: parameters,
                       encoder: encoder,
                       headers: headers,
                       interceptor: interceptor,
                       requestModifier: requestModifier) as DataRequestProtocol
    }
}

extension DataRequest: DataRequestProtocol { }
