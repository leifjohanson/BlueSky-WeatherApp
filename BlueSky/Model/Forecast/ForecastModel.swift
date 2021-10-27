//
//  ForecastModel.swift
//  BlueSky
//
//  Created by Leif Johanson on 10/20/21.
//

import Foundation

struct ForecastModel {
  
    let hTemps: [Double]
    
    let h1Time: Int
    let currentTime: Int
    
    let hIDs: [Int]
    
    let dMaxTemps: [Double]
    let dMinTemps: [Double]
    
    let dIDs: [Int]

    let sunrise: Int
    let sunset: Int
    
    // formats sunrise time from Unix
    var formattedSunrise: String {
        let time = getTime(dt: sunrise, format1: "HH:mm", format2: "h:mm a")
        return time
    }
    
    // formats sunset time from Unix
    var formattedSunset: String {
        let time = getTime(dt: sunset, format1: "HH:mm", format2: "h:mm a")
        return time
    }

    // creates an array of names of the next 4 days
    var forecastDays: [String] {
        let date = Date(timeIntervalSince1970: Double(h1Time))
        
        let dateArray = [Double(date.dayNumberOfWeek()!), Double(date.dayNumberOfWeek()!) + 1, Double(date.dayNumberOfWeek()!) + 2, Double(date.dayNumberOfWeek()!) + 3, Double(date.dayNumberOfWeek()!) + 4]
        var returnArray = [String]()
        for i in dateArray {
            switch i {
            case 1:
                returnArray.append("SUN")
            case 2:
                returnArray.append("MON")
            case 3:
                returnArray.append("TUE")
            case 4:
                returnArray.append("WED")
            case 5:
                returnArray.append("THU")
            case 6:
                returnArray.append("FRI")
            case 7:
                returnArray.append("SAT")
            default:
                returnArray.append("ERR")
            }
        }
        
        return returnArray
    }
    
    // assigns forecast desciption based on ID from API
    func conditionName(conditionID: Int) -> String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "sun.fog.fill"
        case 800:
            return "sun.max.fill"
        default:
            return "cloud.fill"
        }
        
    }

    
    // formats Unix time into standard am/pm time
    func getTime(dt: Int, format1: String, format2: String) -> String {
        let hour = Date(timeIntervalSince1970: Double(dt)).toString(dateFormat: format1)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format1
        
        let date = dateFormatter.date(from: hour)
        dateFormatter.dateFormat = format2
        let dateAmPm = dateFormatter.string(from: date!)
        
        return dateAmPm
    }

    // create times for a 3-hour time interval forecast
    func createTimeArray() -> [String] {
        var returnArray = [String]()
        
        var i = 0
        while i <= 43200 {
            let time = h1Time + i
            returnArray.append(getTime(dt: time, format1: "HH", format2: "h a"))
            i += 10800
        }
        return returnArray
    }
    
    // gets current time
    func getCurrentTime() -> String {
        return Date.init().toString(dateFormat: "HH:mm:ss")
    }
}

extension Date {
    // converts Date to readable String
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    // gives day number based on date
    func dayNumberOfWeek() -> Int? {
            return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

