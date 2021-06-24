//
//  weatherAppUITests.swift
//  weatherAppUITests
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
    
    func testShowWeatherEnabled() {
        let app = XCUIApplication()
        app.launch()
        let showWeather = app.buttons["Show weather"]
        let myGeolocation = app.buttons["My geolocation"]
        XCTAssert(!showWeather.isEnabled)
        myGeolocation.tap()
        app.alerts["Location received"].buttons["OK"].tap()
        XCTAssert(showWeather.isEnabled)
    }
    
    func testShowWeatherEnabled2() {
        let app = XCUIApplication()
        app.launch()
        
        let showWeather = app.buttons["Show weather"]
        let textField = app.textFields["My location"]
        
        XCTAssert(!showWeather.isEnabled)
        textField.tap()
        textField.typeText("Almaty")
        XCTAssert(showWeather.isEnabled)
    }
}
