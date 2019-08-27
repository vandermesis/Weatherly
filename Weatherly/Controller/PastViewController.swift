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
    
    var cityFromNowVC: String?
    var tempFromNowVC: Int?
    var locationFromNovVC: CLLocation?
    
    let pastDataModel = PastDataModel()
    
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        SwiftSky.get([.current], at: locationFromNovVC!, on: Date(timeIntervalSince1970: datePicker.date.timeIntervalSince1970)) { (result) in
            switch result {
            case .success(let forecast):
                print(forecast)
                self.pastDataModel.pastTemperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.pastDataModel.pastIcon = forecast.current?.icon ?? "clear-day"
                self.updateUI()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        pastTempLabel.text = String(pastDataModel.pastTemperature ?? 99)
        pastWeatherIcon.image = UIImage(named: pastDataModel.pastIcon ?? "clear-day")
    }

}
