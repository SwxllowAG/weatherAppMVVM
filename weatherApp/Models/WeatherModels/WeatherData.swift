//
//  WeatherData.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import Foundation

class WeatherData: Decodable {
    // MARK: - Stored properties
    var temp: Double
    var pressure: Double
    var humidity: Double

    // MARK: - Decodable protocol
    enum MainCodingKeys: String, CodingKey {
        case main
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MainCodingKeys.self)
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: MainCodingKeys.main)
        temp = try main.decode(Double.self, forKey: .temp)
        pressure = try main.decode(Double.self, forKey: .pressure)
        humidity = try main.decode(Double.self, forKey: .humidity)
    }
}
