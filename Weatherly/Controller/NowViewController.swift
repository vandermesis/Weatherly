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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Setup notification to trigger refresh current location and data when application come back from the backgroudn
        NotificationCenter.default.addObserver(self, selector:#selector(updateCurrentLocation), name: UIApplication.didBecomeActiveNotification, object: nil)
        updateCurrentLocation()
        configureTableView()
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
    @IBOutlet weak var nowTableView: UITableView!
    
    // MARK: - Configure Location Manager and start updating location data
    @objc func updateCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Get current location data
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            
            // Stop updating location data
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            // Put currentLocation into WeatherDataModel
            weatherDataModel.currentLocation = currentLocation
            
            // Get city name based on current location
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, _) in
                placemarks?.forEach({ (placemark) in
                    if let currentCity = placemark.locality {
                        self.weatherDataModel.currentCity = currentCity
                    }
                })
            }
            print(currentLocation)
            getWeatherData(atLocation: currentLocation)
        }
    }
    
    // If errors with obtaining location occurs update cityLabel
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Unavaiable"
    }
    
    //MARK: - Get current weather data from DarkSkyAPI
    func getWeatherData(atLocation: CLLocation) {
        
        // Configure request
        SwiftSky.secret = "44c90ae04d6f86164e505b107b70e5f6"
        SwiftSky.language = .english
        SwiftSky.locale = .autoupdatingCurrent
        SwiftSky.units.temperature = .celsius
        
        // Request data
        SVProgressHUD.show()
        SwiftSky.get([.current, .hours, .days], at: atLocation) { (result) in
            switch result {
                
            // Update WeatherDataModel if request from api will success
            case .success(let forecast):
                self.weatherDataModel.currentTemperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.weatherDataModel.currentIcon = forecast.current?.icon ?? "clear-day"
                self.weatherDataModel.currentDayHours = forecast.hours?.points
                self.weatherDataModel.dayForecast = forecast.days?.points
                self.nowTableView.reloadData()
//                print(self.weatherDataModel.dayForecast!)
                print(forecast.current!.time.description)
                
            // If errors with obtaining weather data will occure update cityLabel
            case .failure(let error):
                print("Error geting data from DarkSky: \(error)")
                self.cityLabel.text = "Unavaiable"
            }
            SVProgressHUD.dismiss()
            self.updateUI()
        }
    }
    
    // MARK: - Update User Interface with current data
    func updateUI() {
        tempLabel.text = String(weatherDataModel.currentTemperature ?? 99)
        cityLabel.text = weatherDataModel.currentCity
        weatherIcon.image = UIImage(named: weatherDataModel.currentIcon!)
    }
    
    // MARK: - Buttons actions - go to FutureVC or PastVC
    @IBAction func futureButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoFuture", sender: self)
    }
    
    @IBAction func pastButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "gotoPast", sender: self)
    }
    
    
    // MARK: - Pass WeatherDataModel to FutureVC and PastVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoFuture" {
            let futureVC = segue.destination as! FutureTableViewController
            futureVC.weatherDataForecast = weatherDataModel.dayForecast
        }
        if segue.identifier == "gotoPast" {
            let pastVC = segue.destination as! PastViewController
            pastVC.cityFromNowVC = weatherDataModel.currentCity
            pastVC.tempFromNowVC = weatherDataModel.currentTemperature
            pastVC.locationFromNovVC = weatherDataModel.currentLocation
        }
    }
}

// MARK: TableView methods
extension NowViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Setup and configure tableview
    func configureTableView() {
        nowTableView.delegate = self
        nowTableView.dataSource = self
        nowTableView.register(UINib(nibName: "NowCell", bundle: nil), forCellReuseIdentifier: "nowCell")
        nowTableView.separatorStyle = .none
        nowTableView.layer.masksToBounds = true
        nowTableView.layer.borderColor = UIColor.lightGray.cgColor
        nowTableView.layer.borderWidth = 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataModel.currentDayHours?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM HH:hh"
        let cell = nowTableView.dequeueReusableCell(withIdentifier: "nowCell", for: indexPath) as! NowCell
        cell.nowHour.text = dateFormatter.string(from: weatherDataModel.currentDayHours?[indexPath.row].time ?? Date())
        cell.nowTemperature.text = String(Int(round(weatherDataModel.currentDayHours?[indexPath.row].temperature?.current?.value ?? 99))) + "°"
        cell.nowPrecipitation.text = String(weatherDataModel.currentDayHours?[indexPath.row].precipitation?.probability?.value ?? 99) + "%"
        cell.nowWeatherIcon.image = UIImage(named: weatherDataModel.currentDayHours?[indexPath.row].icon ?? "clear-day")
        return cell
    }
    
    
}
