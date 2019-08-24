//
//  NowViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 23/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreLocation
import SwiftSky
import SVProgressHUD

class NowViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start updating location data
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    
    }
    
    

    // MARK: - Constants and Variables
    // Constants
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let weatherDataModel = WeatherDataModel()
    
    // Variables:
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    //MARK: - Get current location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            // Stop updating location data
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            // Get city name based on current location
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, _) in
                placemarks?.forEach({ (placemark) in
                    if let city = placemark.locality {
                        self.weatherDataModel.city = city
                    }
                })
            }
            getWeatherData(atLocation: currentLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavaiable"
    }
    
    //MARK: - Get current weather data from DarkSkyAPI
    func getWeatherData(atLocation: CLLocation) {
        
        // Configure request
        SwiftSky.secret = "866e7c9ce3ac206ce04b8644068470c5"
        SwiftSky.language = .english
        SwiftSky.locale = .autoupdatingCurrent
        SwiftSky.units.temperature = .celsius
        
        // Request data
        SVProgressHUD.show()
        SwiftSky.get([.current], at: atLocation) { (result) in
            switch result {
            case .success(let forecast):
                self.weatherDataModel.temperature = Int(forecast.current?.temperature?.current?.value ?? 99)
            case .failure(let error):
                print(error)
                self.cityLabel.text = "Weather unavaiable"
            }
            SVProgressHUD.dismiss()
            self.updateUI()
        }
    }
    
    // MARK: - Update User Interface with current data
    func updateUI() {
        tempLabel.text = String(weatherDataModel.temperature ?? 99)
        cityLabel.text = weatherDataModel.city
    }
}

