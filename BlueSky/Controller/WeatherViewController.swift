//
//  WeatherViewController.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/19/21.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate, ForecastManagerDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var highAndLowLabel: UILabel!
    
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    

    @IBOutlet weak var tempAndCityView: UIView!
    @IBOutlet weak var forecastView: UIView!
    
    @IBOutlet weak var hourlyForecastView: UIView!
    
    @IBOutlet weak var dailyForecastView: UIView!
    
    @IBOutlet weak var sunriseView: UIView!
    @IBOutlet weak var sunsetView: UIView!

    
    @IBOutlet weak var h1TemperatureLabel: UILabel!
    @IBOutlet weak var h2TemperatureLabel: UILabel!
    @IBOutlet weak var h3TemperatureLabel: UILabel!
    @IBOutlet weak var h4TemperatureLabel: UILabel!
    @IBOutlet weak var h5TemperatureLabel: UILabel!
    
    @IBOutlet weak var h1ImageView: UIImageView!
    @IBOutlet weak var h2ImageView: UIImageView!
    @IBOutlet weak var h3ImageView: UIImageView!
    @IBOutlet weak var h4ImageView: UIImageView!
    @IBOutlet weak var h5ImageView: UIImageView!
    
    @IBOutlet weak var h1HourLabel: UILabel!
    @IBOutlet weak var h2HourLabel: UILabel!
    @IBOutlet weak var h3HourLabel: UILabel!
    @IBOutlet weak var h4HourLabel: UILabel!
    @IBOutlet weak var h5HourLabel: UILabel!
    
    
    
    @IBOutlet weak var d1HighLabel: UILabel!
    @IBOutlet weak var d2HighLabel: UILabel!
    @IBOutlet weak var d3HighLabel: UILabel!
    @IBOutlet weak var d4HighLabel: UILabel!
    @IBOutlet weak var d5HighLabel: UILabel!
    
    @IBOutlet weak var d1LowLabel: UILabel!
    @IBOutlet weak var d2LowLabel: UILabel!
    @IBOutlet weak var d3LowLabel: UILabel!
    @IBOutlet weak var d4LowLabel: UILabel!
    @IBOutlet weak var d5LowLabel: UILabel!
    
    @IBOutlet weak var d1ImageView: UIImageView!
    @IBOutlet weak var d2ImageView: UIImageView!
    @IBOutlet weak var d3ImageView: UIImageView!
    @IBOutlet weak var d4ImageView: UIImageView!
    @IBOutlet weak var d5ImageView: UIImageView!
    
    @IBOutlet weak var d1DayLabel: UILabel!
    @IBOutlet weak var d2DayLabel: UILabel!
    @IBOutlet weak var d3DayLabel: UILabel!
    @IBOutlet weak var d4DayLabel: UILabel!
    @IBOutlet weak var d5DayLabel: UILabel!
    
    
    
    
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    
    
    // creates an instands of WeatherManager and ForecastManager
    var weatherManager = WeatherManager()
    var forecastManager = ForecastManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundCorners([tempAndCityView, forecastView, hourlyForecastView, dailyForecastView, sunriseView, sunsetView])
        
        weatherManager.delegate = self
        forecastManager.delegate = self
        
        searchTextField.delegate = self
        
        weatherManager.getWeather(cityName: "Seattle")
        forecastManager.getForecast(cityName: "Seattle")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.getWeather(cityName: city)
            forecastManager.getForecast(cityName: city)
        }
        searchTextField.text = ""
    }
    
    // handles the update of all Labels and ImageViews
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString + "°F"
            self.cityNameLabel.text = weather.cityName
            self.highAndLowLabel.text = "High: " + weather.highAndLowArray[0] + "°" + " Low: " + weather.highAndLowArray[1] + "°"
            
            self.forecastImageView.image = UIImage(systemName: weather.conditionName)
            self.forecastLabel.text = weather.forecastDescription.capitalized
            
            self.d1HighLabel.text = "H: " + weather.highAndLowArray[0] + "°F"
            self.d1LowLabel.text = "L: " + weather.highAndLowArray[1] + "°F"
            self.d1ImageView.image = UIImage(systemName: weather.conditionName + ".fill")
            
        }
  
    }
    
    // handles the update of all Labels and ImageViews
    func didUpdateForecast(_ forecastManager: ForecastManager, forecast: ForecastModel) {
        DispatchQueue.main.async {
            
            let timeArray = forecast.createTimeArray()
            
            self.h1HourLabel.text = timeArray[0]
            self.h2HourLabel.text = timeArray[1]
            self.h3HourLabel.text = timeArray[2]
            self.h4HourLabel.text = timeArray[3]
            self.h5HourLabel.text = timeArray[4]
                        
            self.h1ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.hIDs[0]))
            self.h2ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.hIDs[1]))
            self.h3ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.hIDs[2]))
            self.h4ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.hIDs[3]))
            self.h5ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.hIDs[4]))
            
            self.h1TemperatureLabel.text = self.tempString(forecast.hTemps[0]) + "°F"
            self.h2TemperatureLabel.text = self.tempString(forecast.hTemps[1]) + "°F"
            self.h3TemperatureLabel.text = self.tempString(forecast.hTemps[2]) + "°F"
            self.h4TemperatureLabel.text = self.tempString(forecast.hTemps[3]) + "°F"
            self.h5TemperatureLabel.text = self.tempString(forecast.hTemps[4]) + "°F"
            
            
            self.d2HighLabel.text = "H: " + String(format: "%.0f", forecast.dMaxTemps[1]) + "°F"
            self.d3HighLabel.text = "H: " + String(format: "%.0f", forecast.dMaxTemps[2]) + "°F"
            self.d4HighLabel.text = "H: " + String(format: "%.0f", forecast.dMaxTemps[3]) + "°F"
            self.d5HighLabel.text = "H: " + String(format: "%.0f", forecast.dMaxTemps[4]) + "°F"
            
            self.d2LowLabel.text = "L: " + String(format: "%.0f", forecast.dMinTemps[1]) + "°F"
            self.d3LowLabel.text = "L: " + String(format: "%.0f", forecast.dMinTemps[2]) + "°F"
            self.d4LowLabel.text = "L: " + String(format: "%.0f", forecast.dMinTemps[3]) + "°F"
            self.d5LowLabel.text = "L: " + String(format: "%.0f", forecast.dMinTemps[4]) + "°F"
            
            self.d1DayLabel.text = "TODAY"
            self.d2DayLabel.text = forecast.forecastDays[1]
            self.d3DayLabel.text = forecast.forecastDays[2]
            self.d4DayLabel.text = forecast.forecastDays[3]
            self.d5DayLabel.text = forecast.forecastDays[4]
        
            self.d2ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.dIDs[1]))
            self.d3ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.dIDs[2]))
            self.d4ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.dIDs[3]))
            self.d5ImageView.image = UIImage(systemName: forecast.conditionName(conditionID: forecast.dIDs[4]))
            
            if(forecast.currentTime < forecast.sunset && forecast.currentTime > forecast.sunrise) {
                self.backgroundImage.image = UIImage(named: "BlueSkyDayBackgroundFinal")
            } else {
                self.backgroundImage.image = UIImage(named: "BlueSkyNightBackgroundFinal")
            }
            
            self.sunriseTimeLabel.text = forecast.formattedSunrise
            self.sunsetTimeLabel.text = forecast.formattedSunset
        }
    }
    
    // prints out error (almost always going to be bad user input to searchTextField
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    // helper functions
    
    // rounds corners of views
    func roundCorners(_ views: [UIView]) {
        for view in views {
            view.layer.cornerRadius = 20;
            view.layer.masksToBounds = true;
        }
    }
    
    // formats string
    func tempString(_ temp: Double) -> String {
        return String(format: "%.0f", temp)
    }
    
}

