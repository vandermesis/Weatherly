//
//  PastViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 24/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import SwiftSky
import CoreLocation
import JGProgressHUD

class PastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pastCityLabel.text = cityFromNowVC
        pastTempLabel.text = String(tempFromNowVC!)
        pastWeatherIcon.image = UIImage(systemName: iconFromNowVC!)
        nowButton.roundBorder()
    }
    
    // MARK: - Constants and Variables
    // Constants
    private let hud = JGProgressHUD(style: .dark)
    //Variables
    private var weatherDataModel = WeatherDataModel()
    var cityFromNowVC: String?
    var tempFromNowVC: Int?
    var iconFromNowVC: String?
    var locationFromNowVC: CLLocation?
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nowButton: UIButton!
    
    // MARK: - DatePicker method
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        //MARK: - Get past weather data from DarkSkyAPI
        hud.show(in: self.view)
        SwiftSky.get([.current], at: locationFromNowVC!, on: Date(timeIntervalSince1970: datePicker.date.timeIntervalSince1970)) { (result) in
            switch result {
            
            // Update WeatherDataModel if request from api will success
            case .success(let forecast):
                self.weatherDataModel.temperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.weatherDataModel.icon = forecast.current?.icon ?? "clear-day"
                self.updateUIWithPastWeatherData()
                print(forecast.current!.time.description)
                print("locationFromVC", self.locationFromNowVC!)
                
            // If errors with obtaining weather data will occure update cityLabel
            case .failure(let error):
                self.pastCityLabel.text = "Unavailable"
                print("Error geting data from DarkSky: \(error)")
            }
            self.hud.dismiss()
        }
    }
    
    // MARK: - Buttons
    
    // Button action - dismiss PastVC and go back to NowVC
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update User Interface
    
    // Update UI with current data
    private func updateUIWithPastWeatherData() {
        pastTempLabel.text = String(weatherDataModel.temperature ?? 99)
        pastWeatherIcon.image = UIImage(systemName: weatherDataModel.sfSymbol)
    }
}
