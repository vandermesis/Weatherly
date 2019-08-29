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
        pastWeatherIcon.image = UIImage(named: iconFromNowVC!)
        updateUIColors()
    }
    
    // MARK: - Constants and Variables
    // Constants
    let pastDataModel = PastDataModel()
    
    //Variables
    var cityFromNowVC: String?
    var tempFromNowVC: Int?
    var iconFromNowVC: String?
    var locationFromNowVC: CLLocation?
    var dayTimeFromNowVC: Bool?
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nowButtonImage: UIButton!
    
    // MARK: - DatePicker method
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        //MARK: - Get past weather data from DarkSkyAPI
        SwiftSky.get([.current], at: locationFromNowVC!, on: Date(timeIntervalSince1970: datePicker.date.timeIntervalSince1970)) { (result) in
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
    
    // MARK: - Update User Interface
    
    // Update UI with current data
    func updateUI() {
        pastTempLabel.text = String(pastDataModel.pastTemperature ?? 99)
        if dayTimeFromNowVC ?? true {
            pastWeatherIcon.image = UIImage(named: pastDataModel.pastIcon ?? "clear-day")
        } else {
            pastWeatherIcon.image = invertImageColors(weatherIcon: UIImage(named: pastDataModel.pastIcon ?? "clear-day")!)
        }
        
    }
    
    // Invert FutureVC colors during night time
    func updateUIColors() {
        let nowButton = "icons8-circled-notch-100"
        if dayTimeFromNowVC ?? true {
            self.view.backgroundColor = .white
            pastTempLabel.textColor = .black
            pastCityLabel.textColor = .black
            datePicker.backgroundColor = .white
            datePicker.tintColor = .black
            datePicker.setValue(UIColor.black, forKeyPath: "textColor")
            nowButtonImage.setImage(UIImage(named: nowButton), for: .normal)
            pastWeatherIcon.image = UIImage(named: iconFromNowVC ?? "clear-day")
        } else {
            self.view.backgroundColor = .black
            pastTempLabel.textColor = .white
            pastCityLabel.textColor = .white
            datePicker.backgroundColor = .black
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
            nowButtonImage.setImage(invertImageColors(weatherIcon: UIImage(named: nowButton)!), for: .normal)
            pastWeatherIcon.image = invertImageColors(weatherIcon: UIImage(named: iconFromNowVC ?? "clear-day")!)
        }
    }
    
    // Filter to invert colors of images
    func invertImageColors(weatherIcon: UIImage) -> UIImage? {
        let beginImage = CIImage(image: weatherIcon)
        var newImage: UIImage?
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            newImage = UIImage(ciImage: filter.outputImage!)
        }
        return newImage
    }

}
