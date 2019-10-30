//
//  WeatherDataModel.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 24/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import Foundation
import SwiftSky
import CoreLocation

struct WeatherDataModel {
    
    // Store data from DarkSky api for use in NowViewController
    var currentTemperature: Int?
    var currentCity: String?
    var currentIcon: String?
    var currentDayHours: [DataPoint]?
    var currentLocation: CLLocation?
    
    // Store data from DarkSky api for use in FutureViewController
    var dayForecast: [DataPoint]?
    
    // Store data from DarkSky api for use in PastViewController
    var pastTemperature: Int?
    var pastIcon: String?
    
    func convert(icon: String) -> String {
        switch icon {
        case "clear-day":
            return "sun.max"
        case "clear-night":
            return "moon"
        case "cloudy":
            return "cloud"
        case "fog":
            return "cloud.fog"
        case "partly-cloudy-day":
            return "cloud.sun"
        case "partly-cloudy-night":
            return "cloud.moon"
        case "rain":
            return "cloud.rain"
        case "sleet":
            return "cloud.sleet"
        case "snow":
            return "cloud.snow"
        case "wind":
            return "wind"
        default:
            return "nosign"
        }
    }
}
