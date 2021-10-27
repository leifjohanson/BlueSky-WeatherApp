//
//  ForecastManager.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/20/21.
//

import Foundation

protocol ForecastManagerDelegate {
    func didUpdateForecast(_ forecastManager: ForecastManager, forecast: ForecastModel)
    func didFailWithError(error: Error)
}

struct ForecastManager {
    // forecast API url
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=025e05bc69946ef318a448df4d8e55c7&units=imperial&q="
    
    var delegate: ForecastManagerDelegate?
    
    // formats URL and calls performRequest, called after UITextField is done editing
    func getForecast(cityName: String) {
        let string = cityName
        let replaced = (string as NSString).replacingOccurrences(of: " ", with: "+")
        let urlString = forecastURL + replaced
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
                    if let forecast = self.parseJSON(safeData) {
                        self.delegate?.didUpdateForecast(self, forecast: forecast)
                    }
                }
            }
            task.resume()
        }
    }
    
    // parses JSON and passes gets data from ForecastModel
    func parseJSON(_ forecastData: Data) -> ForecastModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)

            let threeAMIndex = [decodedData.list[0].dt_txt, decodedData.list[1].dt_txt, decodedData.list[2].dt_txt, decodedData.list[3].dt_txt, decodedData.list[4].dt_txt, decodedData.list[5].dt_txt, decodedData.list[6].dt_txt, decodedData.list[7].dt_txt].get3AMIndex()
            
            let threePMIndex = [decodedData.list[0].dt_txt, decodedData.list[1].dt_txt, decodedData.list[2].dt_txt, decodedData.list[3].dt_txt, decodedData.list[4].dt_txt, decodedData.list[5].dt_txt, decodedData.list[6].dt_txt, decodedData.list[7].dt_txt].get3PMIndex()
            
            let hTemps = [decodedData.list[0].main.temp, decodedData.list[1].main.temp, decodedData.list[2].main.temp, decodedData.list[3].main.temp, decodedData.list[4].main.temp]
            
            let h1Time = decodedData.list[0].dt + decodedData.city.timezone
            let curTime = Int(Int(NSDate.init().timeIntervalSince1970) + decodedData.city.timezone)
            
            let hIDs = [decodedData.list[0].weather[0].id, decodedData.list[1].weather[0].id, decodedData.list[2].weather[0].id, decodedData.list[3].weather[0].id, decodedData.list[4].weather[0].id]
            
            // gets daily maximum temperature
            let d2Max = [decodedData.list[threePMIndex].main.temp_max, decodedData.list[threePMIndex + 1].main.temp_max, decodedData.list[threePMIndex + 2].main.temp_max, decodedData.list[threePMIndex + 3].main.temp_max, decodedData.list[threePMIndex + 4].main.temp_max, decodedData.list[threePMIndex + 5].main.temp_max, decodedData.list[threePMIndex + 6].main.temp_max, decodedData.list[threePMIndex + 7].main.temp_max].max()
            let d3Max = [decodedData.list[threePMIndex + 8].main.temp_max, decodedData.list[threePMIndex + 9].main.temp_max, decodedData.list[threePMIndex + 10].main.temp_max, decodedData.list[threePMIndex + 11].main.temp_max, decodedData.list[threePMIndex + 12].main.temp_max, decodedData.list[threePMIndex + 13].main.temp_max, decodedData.list[threePMIndex + 14].main.temp_max, decodedData.list[threePMIndex + 15].main.temp_max].max()
            let d4Max = [decodedData.list[threePMIndex + 16].main.temp_max, decodedData.list[threePMIndex + 17].main.temp_max, decodedData.list[threePMIndex + 18].main.temp_max, decodedData.list[threePMIndex + 19].main.temp_max, decodedData.list[threePMIndex + 20].main.temp_max, decodedData.list[threePMIndex + 21].main.temp_max, decodedData.list[threePMIndex + 22].main.temp_max, decodedData.list[threePMIndex + 23].main.temp_max].max()
            let d5Max = [decodedData.list[threePMIndex + 24].main.temp_max, decodedData.list[threePMIndex + 25].main.temp_max, decodedData.list[threePMIndex + 26].main.temp_max, decodedData.list[threePMIndex + 27].main.temp_max, decodedData.list[threePMIndex + 28].main.temp_max, decodedData.list[threePMIndex + 29].main.temp_max, decodedData.list[threePMIndex + 30].main.temp_max, decodedData.list[threePMIndex + 31].main.temp_max].max()
        
            // 0 index is -1 because current days data is taken from WeatherModel
            let dMaxTemps = [-1, d2Max!, d3Max!, d4Max!, d5Max!]
            
            // gets daily minimum temperature
            let d2Min = [decodedData.list[threeAMIndex + 0].main.temp_min, decodedData.list[threeAMIndex + 1].main.temp_min, decodedData.list[threeAMIndex + 2].main.temp_min, decodedData.list[threeAMIndex + 3].main.temp_min, decodedData.list[threeAMIndex + 4].main.temp_min, decodedData.list[threeAMIndex + 5].main.temp_min, decodedData.list[threeAMIndex + 6].main.temp_min, decodedData.list[threeAMIndex + 7].main.temp_min].min()
            let d3Min = [decodedData.list[threeAMIndex + 8].main.temp_min, decodedData.list[threeAMIndex + 9].main.temp_min, decodedData.list[threeAMIndex + 10].main.temp_min, decodedData.list[threeAMIndex + 11].main.temp_min, decodedData.list[threeAMIndex + 12].main.temp_min, decodedData.list[threeAMIndex + 13].main.temp_min, decodedData.list[threeAMIndex + 14].main.temp_min, decodedData.list[threeAMIndex + 15].main.temp_min].min()
            let d4Min = [decodedData.list[threeAMIndex + 16].main.temp_min, decodedData.list[threeAMIndex + 17].main.temp_min, decodedData.list[threeAMIndex + 18].main.temp_min, decodedData.list[threeAMIndex + 19].main.temp_min, decodedData.list[threeAMIndex + 20].main.temp_min, decodedData.list[threeAMIndex + 21].main.temp_min, decodedData.list[threeAMIndex + 22].main.temp_min, decodedData.list[threeAMIndex + 23].main.temp_min].min()
            let d5Min = [decodedData.list[threeAMIndex + 24].main.temp_min, decodedData.list[threeAMIndex + 25].main.temp_min, decodedData.list[threeAMIndex + 26].main.temp_min, decodedData.list[threeAMIndex + 27].main.temp_min, decodedData.list[threeAMIndex + 28].main.temp_min, decodedData.list[threeAMIndex + 29].main.temp_min, decodedData.list[threeAMIndex + 30].main.temp_min, decodedData.list[threeAMIndex + 31].main.temp_min].min()
            
            // 0 index is -1 because current days data is taken from WeatherModel
            let dMinTemps = [-1, d2Min!, d3Min!, d4Min!, d5Min!]
            
            let dIDs = [decodedData.list[threePMIndex].weather[0].id, decodedData.list[threePMIndex + 8].weather[0].id, decodedData.list[threePMIndex + 16].weather[0].id, decodedData.list[threePMIndex + 24].weather[0].id, decodedData.list[threePMIndex + 32].weather[0].id]
            
            let sunrise = decodedData.city.sunrise + decodedData.city.timezone
            let sunset = decodedData.city.sunset + decodedData.city.timezone
            
            let forecast = ForecastModel(hTemps: hTemps, h1Time: h1Time, currentTime: curTime, hIDs: hIDs, dMaxTemps: dMaxTemps, dMinTemps: dMinTemps, dIDs: dIDs, sunrise: sunrise, sunset: sunset)
            
            return forecast
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

extension Array where Element == String{
    // finds out which list index contains 3AM
    func get3AMIndex() -> Int {
        for i in 0...(self.count - 1) {
            let time = self[i].split(separator: " ")[1]
            if(time.contains("3:00:00")) {
                return i
            }
            
        }
        
        return -1
    }
    
    // find out which list index contains 3PM
    func get3PMIndex() -> Int {
        for i in 0...(self.count - 1) {
            let time = self[i].split(separator: " ")[1]
            if(time.contains("15:00:00")) {
                return i
            }
            
        }
        
        return -1
    }
}
