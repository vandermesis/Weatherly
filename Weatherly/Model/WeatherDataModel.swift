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

class WeatherDataModel {
    
    // Store data from DarkSky api for use in NowViewController
    var currentTemperature: Int?
    var currentCity: String?
    var currentIcon: String?
    var currentHour: Date?
    var currentDayHours: [DataPoint]?
    var currentLocation: CLLocation?
    
    // Store data from DarkSky api for use in FutureViewController
    var dayForecast: [DataPoint]?
    
}
