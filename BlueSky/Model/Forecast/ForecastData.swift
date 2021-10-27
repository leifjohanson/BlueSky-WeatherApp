//
//  ForecastData.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/20/21.
//

import Foundation

struct ForecastData: Decodable {
    let list: [List]
    let city: City
}

struct List: Decodable {
    let dt: Int
    let dt_txt: String
    let main: MainForecast
    let weather: [WeatherForecast]
}

struct MainForecast: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherForecast: Decodable {
    let id: Int
}

struct City: Decodable {
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
