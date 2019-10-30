//
//  NowViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 23/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftSky
import JGProgressHUD

class NowViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Get apiKey
        decodeKey()
        
        // Setup buttons with round borders
        pastButton.roundBorder()
        futureButton.roundBorder()
        
        configureTableView()
        
        // Setup notification to trigger refresh current location and data when application come back from the backgroudn
        if favoritesMode == false {
            NotificationCenter.default.addObserver(self, selector:#selector(updateCurrentLocation), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        
    }

    // MARK: - Constants and Variables
    // Constants
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let dateFormatter = DateFormatter()
    private let hud = JGProgressHUD(style: .dark)
    
    // Variables:
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityButtonLabel: UIButton!
    @IBOutlet weak var nowTableView: UITableView!
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var futureButton: UIButton!
    private var favoritesMode = false
    private var weatherDataModel = WeatherDataModel()
    private var secret: Secrets?
    
    // MARK: - Configure Location Manager and start updating location data
    @objc private func updateCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Get apiKey
    private func decodeKey() {
        let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath!))
            secret = try PropertyListDecoder().decode(Secrets.self, from: data)
        } catch {
            print("Error in \(#function): \(error.localizedDescription)")
        }
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
            getPlace(for: currentLocation) { (placemark) in
                guard let placemark = placemark else { return }
                if let currentCity = placemark.locality {
                    self.weatherDataModel.currentCity = currentCity
                    self.cityButtonLabel.setTitle(currentCity, for: .normal)
                }
            }
            getWeatherData(atLocation: currentLocation)
            print("Current location: ", currentLocation)
        }
    }
    
    // If errors with obtaining location occurs update cityLabel
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityButtonLabel.setTitle("Unavaiable", for: .normal)
    }
    
    // MARK: - Convert coordinates to city names and back - - thanks to https://github.com/davidseek/Swift101ConvertCoordinates
    // Get city name from location
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            completion(placemark)
        }
    }
    
    // Get location of place entered by user
    func getLocation(forPlaceCalled name: String, completion: @escaping(CLLocation?) -> Void) {
        geoCoder.geocodeAddressString(name) { placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            guard let location = placemark.location else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
    //MARK: - Get current weather data from DarkSkyAPI
    private func getWeatherData(atLocation: CLLocation) {
        
        // Configure request
        if let key = secret?.apiKey {
            SwiftSky.secret = key
            SwiftSky.language = .english
            SwiftSky.locale = .autoupdatingCurrent
            SwiftSky.units.temperature = .celsius
        }
        // Request data
        hud.show(in: self.view)
        SwiftSky.get([.current, .hours, .days], at: atLocation) { (result) in
            switch result {
                
            // Update WeatherDataModel if request from api will success
            case .success(let forecast):
                self.weatherDataModel.currentTemperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.weatherDataModel.currentIcon = forecast.current?.icon ?? "clear-day"
                self.weatherDataModel.currentDayHours = forecast.hours?.points
                self.weatherDataModel.dayForecast = forecast.days?.points
                self.nowTableView.reloadData()
                print("Current time from DarkSky:", forecast.current!.time.description)
                
            // If errors with obtaining weather data will occure update cityLabel
            case .failure(let error):
                print("Error geting data from DarkSky: \(error)")
                self.cityButtonLabel.setTitle("Unavaiable", for: .normal)
            }
            self.hud.dismiss()
            self.updateUI()
        }
    }
    
    // MARK: - Update User Interface with current data
    private func updateUI() {
        tempLabel.text = String(weatherDataModel.currentTemperature ?? 99)
        cityButtonLabel.setTitle(weatherDataModel.currentCity ?? "Luna", for: .normal)
        weatherIcon.image = UIImage(systemName: weatherDataModel.convert(icon: weatherDataModel.currentIcon!))
    }
    
    // MARK: - Buttons
    // Navigation buttons appearance
    
    // Buttons actions
    // Go to FutureVC or PastVC
    @IBAction func futureButtonPressed(_ sender: UIButton) {
        if weatherDataModel.dayForecast != nil {
            performSegue(withIdentifier: "gotoFuture", sender: self)
        }
    }
    
    @IBAction func pastButtonPressed(_ sender: Any) {
        if weatherDataModel.currentTemperature != nil {
            performSegue(withIdentifier: "gotoPast", sender: self)
        }
    }
    
    // User enters a new city name
    @IBAction func cityButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoFavorites", sender: self)
    }
    
    // MARK: - Pass WeatherDataModel to FutureVC and PastVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoFuture" {
            let futureVC = segue.destination as! FutureTableViewController
            futureVC.weatherDataForecast = weatherDataModel.dayForecast
            futureVC.cityFromNowVC = weatherDataModel.currentCity
        }
        if segue.identifier == "gotoPast" {
            let pastVC = segue.destination as! PastViewController
            pastVC.cityFromNowVC = weatherDataModel.currentCity
            pastVC.tempFromNowVC = weatherDataModel.currentTemperature
            pastVC.iconFromNowVC = weatherDataModel.currentIcon
            pastVC.locationFromNowVC = weatherDataModel.currentLocation
        }
        if segue.identifier == "gotoFavorites" {
            let favoritesVC = segue.destination as! FavoritesViewController
            favoritesVC.delegate = self
        }
    }
}

// MARK: TableView methods
extension NowViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Setup and configure tableview
    private func configureTableView() {
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
        dateFormatter.dateFormat = "dd.MM HH:00"
        let cell = nowTableView.dequeueReusableCell(withIdentifier: "nowCell", for: indexPath) as! NowCell
        cell.nowHour.text = dateFormatter.string(from: weatherDataModel.currentDayHours?[indexPath.row].time ?? Date())
        cell.nowTemperature.text = String(Int(round(weatherDataModel.currentDayHours?[indexPath.row].temperature?.current?.value ?? 99))) + "°"
        cell.nowPrecipitation.text = String(weatherDataModel.currentDayHours?[indexPath.row].precipitation?.probability?.value ?? 99) + "%"
        cell.nowWeatherIcon.image = UIImage(named: weatherDataModel.currentDayHours?[indexPath.row].icon ?? "clear-day")
        cell.umbrellaIcon.image = UIImage(systemName: "umbrella")
        return cell
    }
}

// MARK: Get city from FavoritesViewController and present weather data for city location
extension NowViewController: CanReceive {
    
    // Switch favorites mode on/off to make NowVC load or not current location on viewWillAppear
    func setFavorites(mode: Bool) {
        favoritesMode = mode
    }
    
    // Use user city to get current weather data for city's location
    func userEntered(city: String) {
        print("City passed from FavoritesVC: \(city)")
        favoritesMode = true
        weatherDataModel.currentCity = city
        cityButtonLabel.setTitle(city, for: .normal)
        getLocation(forPlaceCalled: city) { (location) in
            if let cityLocation = location {
                self.weatherDataModel.currentLocation = cityLocation
                self.getWeatherData(atLocation: cityLocation)
            }
        }
    }
}

extension UIButton {
    func roundBorder() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.label.cgColor
    }
}
