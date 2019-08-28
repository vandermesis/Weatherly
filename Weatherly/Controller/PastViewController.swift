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

class PastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pastCityLabel.text = cityFromNowVC
        pastTempLabel.text = String(tempFromNowVC!)
    }
    
    // MARK: - Constants and Variables
    // Constants
    let pastDataModel = PastDataModel()
    
    //Variables
    var cityFromNowVC: String?
    var tempFromNowVC: Int?
    var locationFromNovVC: CLLocation?
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - DatePicker method
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        //MARK: - Get past weather data from DarkSkyAPI
        SwiftSky.get([.current], at: locationFromNovVC!, on: Date(timeIntervalSince1970: datePicker.date.timeIntervalSince1970)) { (result) in
            switch result {
            
            // Update WeatherDataModel if request from api will success
            case .success(let forecast):
                print(forecast.current!.time.description)
                self.pastDataModel.pastTemperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.pastDataModel.pastIcon = forecast.current?.icon ?? "clear-day"
                self.updateUI()
                
            // If errors with obtaining weather data will occure update cityLabel
            case .failure(let error):
                self.pastCityLabel.text = "Unavailable"
                print("Error geting data from DarkSky: \(error)")
            }
        }
    }
    
    // MARK: - Button action - dismiss PastVC and go back to NowVC
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update User Interface with current data
    func updateUI() {
        pastTempLabel.text = String(pastDataModel.pastTemperature ?? 99)
        pastWeatherIcon.image = UIImage(named: pastDataModel.pastIcon ?? "clear-day")
    }

}
