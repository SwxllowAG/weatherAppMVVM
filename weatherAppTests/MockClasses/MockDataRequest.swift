//
//  MockDataRequest.swift
//  weatherAppTests
//
//  Created by Galym Anuarbek on 24.06.2021.
//

import Foundation
import Alamofire

@testable import weatherApp

internal class MockDataRequest: DataRequestProtocol {
    private (set) var responseCalled = false
    
    let url: URL?
    let error: Error?
    let data: Data?
    let success: Bool
    
    init(url: URL?, error: Error?, data: Data?, success: Bool) {
        self.url = url
        self.error = error
        self.data = data
        self.success = success
    }
    
    func responseJSON(queue: DispatchQueue,
                      dataPreprocessor: DataPreprocessor,
                      emptyResponseCodes: Set<Int>,
                      emptyRequestMethods: Set<HTTPMethod>,
                      options: JSONSerialization.ReadingOptions,
                      completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self {
        responseCalled = true
        let response = success ? successHttpURLResponse() : wrongHttpURLResponse(statusCode: 400)
        let result = success
            ? Result.success(data as Any)
            : Result.failure(AFError.explicitlyCancelled)
        let dataResponse = AFDataResponse(request: nil, response: response, data: data,
                                          metrics: nil, serializationDuration: 0, result: result)
        completionHandler(dataResponse)
        return self
    }
    
    func successHttpURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: self.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }

    func wrongHttpURLResponse(statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: self.url!, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
}

internal class MockSession: SessionProtocol {
    var success = true
    var isNilData = false

    var jsonData: Data = {
        let jsonString = "{ \"success\": true }"
        return (try? JSONEncoder().encode(jsonString)) ?? Data()
    }()

    private (set) var lastURL: URL?

    func myRequest(_ convertible: URLConvertible,
                   method: HTTPMethod,
                   parameters: [String: String]?,
                   encoder: ParameterEncoder,
                   headers: HTTPHeaders?,
                   interceptor: RequestInterceptor?,
                   requestModifier: ((inout URLRequest) throws -> Void)?) -> DataRequestProtocol {
        lastURL = try? convertible.asURL()
        let error: Error? = success ? nil : NSError(domain: "", code: 400, userInfo: [:])
        let data = isNilData ? nil : jsonData
        let request = MockDataRequest(url: lastURL, error: error, data: data, success: success)
        return request
    }

    func setDataFromString(_ string: String) {
        self.jsonData = (try? JSONEncoder().encode(string)) ?? Data()
    }
}
