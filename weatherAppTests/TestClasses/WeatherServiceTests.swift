//
//  weatherAppTests.swift
//  weatherAppTests
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import XCTest
@testable import weatherApp

class WeatherServiceTests: XCTestCase {

    let mockSession = MockSession()
    lazy var mockService = WeatherService(sessionManager: mockSession)
    lazy var realService = WeatherService()

    func testFailCityName() throws {
        let expect = expectation(description: #function)
        mockSession.setDataFromString("{ \"success\": false }")
        mockSession.isNilData = false
        mockSession.success = false
        mockService.obtainWeatherByCityName(text: "Almaty") { weatherData, errorStr in
            XCTAssert(weatherData == nil)
            XCTAssert(errorStr != nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFailLocation() throws {
        let expect = expectation(description: #function)
        mockSession.setDataFromString("{ \"success\": false }")
        mockSession.isNilData = false
        mockSession.success = false
        mockService.obtainWeatherByCoordinates(lat: 0, lon: 0) { weatherData, errorStr in
            XCTAssert(weatherData == nil)
            XCTAssert(errorStr != nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSuccessInvalidDataCityName() throws {
        let expect = expectation(description: #function)
        mockSession.setDataFromString("{ \"success\": true }")
        mockSession.isNilData = false
        mockSession.success = true
        mockService.obtainWeatherByCityName(text: "Almaty") { weatherData, errorStr in
            XCTAssert(weatherData == nil)
            XCTAssert(errorStr == "Unrecognizable data")
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSuccessInvalidDataLocation() throws {
        let expect = expectation(description: #function)
        mockSession.setDataFromString("{ \"success\": true }")
        mockSession.isNilData = false
        mockSession.success = true
        mockService.obtainWeatherByCoordinates(lat: 0, lon: 0) { weatherData, errorStr in
            XCTAssert(weatherData == nil)
            XCTAssert(errorStr == "Unrecognizable data")
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSuccessCityName() throws {
        guard
            let path = Bundle(for: WeatherServiceTests.self).url(forResource: "weatherData", withExtension: "txt"),
            let contents = try? Data(contentsOf: path)
        else { XCTAssert(false); return }
        let expect = expectation(description: #function)
        mockSession.jsonData = contents
        mockSession.isNilData = false
        mockSession.success = true
        mockService.obtainWeatherByCityName(text: "Almaty") { weatherData, errorStr in
            XCTAssert(weatherData?.humidity == 100)
            XCTAssert(weatherData?.temp == 282.55)
            XCTAssert(weatherData?.pressure == 1023)
            XCTAssert(errorStr == nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSuccessLocation() throws {
        guard
            let path = Bundle(for: WeatherServiceTests.self).url(forResource: "weatherData", withExtension: "txt"),
            let contents = try? Data(contentsOf: path)
        else { XCTAssert(false); return }
        let expect = expectation(description: #function)
        mockSession.jsonData = contents
        mockSession.isNilData = false
        mockSession.success = true
        mockService.obtainWeatherByCoordinates(lat: 0, lon: 0) { weatherData, errorStr in
            XCTAssert(weatherData != nil)
            XCTAssert(weatherData?.humidity == 100)
            XCTAssert(weatherData?.temp == 282.55)
            XCTAssert(weatherData?.pressure == 1023)
            XCTAssert(errorStr == nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testRealCityName() throws {
        let expect = expectation(description: #function)
        realService.obtainWeatherByCityName(text: "Almaty") { weatherData, error in
            assert(weatherData != nil)
            assert(error == nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testRealLocation() throws {
        let expect = expectation(description: #function)
        realService.obtainWeatherByCoordinates(lat: 43.261197043305664, lon: 76.93130562175504) { weatherData, error in
            assert(weatherData != nil)
            assert(error == nil)
            expect.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

}
