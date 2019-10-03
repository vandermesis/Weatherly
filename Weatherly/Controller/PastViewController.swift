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
import SVProgressHUD

class PastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pastCityLabel.text = cityFromNowVC
        pastTempLabel.text = String(tempFromNowVC!)
        pastWeatherIcon.image = UIImage(named: iconFromNowVC!)
        roundBorder(button: nowButton)
        updateUIColors()
    }
    
    // MARK: - Constants and Variables
    // Constants
    
    //Variables
    private var pastDataModel = PastDataModel()
    var cityFromNowVC: String?
    var tempFromNowVC: Int?
    var iconFromNowVC: String?
    var locationFromNowVC: CLLocation?
    var dayTimeFromNowVC: Bool?
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nowButton: UIButton!
    
    // MARK: - DatePicker method
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        //MARK: - Get past weather data from DarkSkyAPI
        SVProgressHUD.show()
        SwiftSky.get([.current], at: locationFromNowVC!, on: Date(timeIntervalSince1970: datePicker.date.timeIntervalSince1970)) { (result) in
            switch result {
            
            // Update WeatherDataModel if request from api will success
            case .success(let forecast):
                self.pastDataModel.pastTemperature = Int(round(forecast.current?.temperature?.current?.value ?? 99))
                self.pastDataModel.pastIcon = forecast.current?.icon ?? "clear-day"
                self.updateUIWithPastWeatherData()
                print(forecast.current!.time.description)
                print("locationFromVC", self.locationFromNowVC!)
                
            // If errors with obtaining weather data will occure update cityLabel
            case .failure(let error):
                self.pastCityLabel.text = "Unavailable"
                print("Error geting data from DarkSky: \(error)")
            }
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Buttons
    // Button appearance
    private func roundBorder(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        if dayTimeFromNowVC ?? true {
            button.layer.borderColor = UIColor.black.cgColor
        } else {
            button.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    // Button action - dismiss PastVC and go back to NowVC
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Update User Interface
    
    // Update UI with current data
    private func updateUIWithPastWeatherData() {
        pastTempLabel.text = String(pastDataModel.pastTemperature ?? 99)
        if dayTimeFromNowVC ?? true {
            pastWeatherIcon.image = UIImage(named: pastDataModel.pastIcon ?? "clear-day")
        } else {
            pastWeatherIcon.image = invertImageColors(weatherIcon: UIImage(named: pastDataModel.pastIcon ?? "clear-day")!)
        }
        
    }
    
    // Invert FutureVC colors during night time
    private func updateUIColors() {
        if dayTimeFromNowVC ?? true {
            self.view.backgroundColor = .white
            pastTempLabel.textColor = .black
            pastCityLabel.textColor = .black
            datePicker.backgroundColor = .white
            datePicker.tintColor = .black
            datePicker.setValue(UIColor.black, forKeyPath: "textColor")
            pastWeatherIcon.image = UIImage(named: iconFromNowVC ?? "clear-day")
            nowButton.setTitleColor(.black, for: .normal)
        } else {
            self.view.backgroundColor = .black
            pastTempLabel.textColor = .white
            pastCityLabel.textColor = .white
            datePicker.backgroundColor = .black
            datePicker.setValue(UIColor.white, forKeyPath: "textColor")
            nowButton.setTitleColor(.white, for: .normal)
            pastWeatherIcon.image = invertImageColors(weatherIcon: UIImage(named: iconFromNowVC ?? "clear-day")!)
        }
    }
    
    // Filter to invert colors of images
    private func invertImageColors(weatherIcon: UIImage) -> UIImage? {
        let beginImage = CIImage(image: weatherIcon)
        var newImage: UIImage?
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            newImage = UIImage(ciImage: filter.outputImage!)
        }
        return newImage
    }

}
