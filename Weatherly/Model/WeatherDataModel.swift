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
    
    // Data for NowViewController
    var currentTemperature: Int?
    var currentCity: String?
    var currentIcon: String?
    var currentDayHours: [DataPoint]?
    var currentLocation: CLLocation?
    
    // Data for FutureViewController
    var dayForecast: [DataPoint]?
    
}
