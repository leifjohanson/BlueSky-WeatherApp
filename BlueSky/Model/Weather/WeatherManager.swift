//
//  WeatherManager.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/19/21.
//

import Foundation
import CloudKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // weather API url
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?&appid=025e05bc69946ef318a448df4d8e55c7&units=imperial&q="
   
    var delegate: WeatherManagerDelegate?
    
    // formats URL and calls performRequest, called after UITextField is done editing
    func getWeather(cityName: String) {
        let string = cityName
        let replaced = (string as NSString).replacingOccurrences(of: " ", with: "+")
        let urlString = weatherURL + replaced
        performRequest(with: urlString)
    }
    
    // performs API request
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    // parses JSON and passes gets data from ForecastModel
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            let description = decodedData.weather[0].description
            let high = decodedData.main.temp_max
            let low = decodedData.main.temp_min
            
            let weather = WeatherModel(conditionID: id, cityName: cityName, temperature: temp, highTemp: high, lowTemp: low, forecastDescription: description)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
