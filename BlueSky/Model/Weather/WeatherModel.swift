//
//  WeatherModel.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/20/21.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let highTemp: Double
    let lowTemp: Double
    let forecastDescription: String
    
    
    // formats the current temperature as a string
    var temperatureString: String {
        return String(Int(temperature))
    }
    
    // formats current high and low temps
    var highAndLowArray: [String] {
        return [String(Int(highTemp)), String(Int(lowTemp))]
    }
    
    // assigns forecast desciption based on ID from API
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "sun.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
        
    }
    
}
