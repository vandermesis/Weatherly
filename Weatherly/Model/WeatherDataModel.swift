//
//  WeatherDataModel.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 24/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import Foundation
import SwiftSky

class WeatherDataModel {
    
    // Data for NowViewController
    var currentTemperature: Int?
    var currentCity: String?
    var currentIcon: String?
    
    // Data for FutureViewController
    var dayForecast: [DataPoint]?
    var dayTemperature: [Int]?
    var dayIcon: [String]?
    
    func dayFromDate(date: Date) {
        let dateFormatter = DateFormatter()
        print(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1])
    }
}
