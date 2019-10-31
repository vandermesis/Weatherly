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
    
    // Store data from DarkSky API
    var temperature: Int?
    var city: String?
    var icon: String?
    var hours: [DataPoint]?
    var days: [DataPoint]?
    var location: CLLocation?
    
    var hoursSymbol: [String] {
        var symbols = [String]()
        if let hours = hours {
            for hour in hours {
                switch hour.icon {
                case "clear-day":
                    symbols.append("sun.max")
                case "clear-night":
                    symbols.append("moon")
                case "cloudy":
                    symbols.append("cloud")
                case "fog":
                    symbols.append("cloud.fog")
                case "partly-cloudy-day":
                    symbols.append("cloud.sun")
                case "partly-cloudy-night":
                    symbols.append("cloud.moon")
                case "rain":
                    symbols.append("cloud.rain")
                case "sleet":
                    symbols.append("cloud.sleet")
                case "snow":
                    symbols.append("cloud.snow")
                case "wind":
                    symbols.append("wind")
                default:
                    symbols.append("nosign")
                }
            }
        } else {
            return ["sun.max"]
        }
        return symbols
    }
    
    var sfSymbol: String {
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
