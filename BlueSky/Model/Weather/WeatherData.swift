//
//  WeatherData.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/20/21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

