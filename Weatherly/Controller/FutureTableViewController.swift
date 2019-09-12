//
//  FutureTableViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 24/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import SwiftSky

class FutureTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        futureCityLabel.text = cityFromNowVC
        configureTableView()
        roundBorder(button: nowButton)
    }
    
    // MARK: - Variables
    var weatherDataForecast: [DataPoint]?
    var dayTimeFromNowVC: Bool?
    var cityFromNowVC: String?
    @IBOutlet weak var futureTableView: UITableView!
    @IBOutlet weak var futureCityLabel: UILabel!
    @IBOutlet weak var nowButton: UIButton!
    
    // MARK: - Buttons
    // Button appearance
    func roundBorder(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        if dayTimeFromNowVC ?? true {
            button.layer.borderColor = UIColor.black.cgColor
        } else {
            button.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    // Button action - dismiss FutureVC and go back to NowVC
    @IBAction func nowButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView methods
    
    // Setup and configure tableview
    func configureTableView() {
        futureTableView.delegate = self
        futureTableView.dataSource = self
        futureTableView.register(UINib(nibName: "FutureCell", bundle: nil), forCellReuseIdentifier: "futureCell")
        futureTableView.separatorStyle = .none
        futureTableView.layer.masksToBounds = true
        futureTableView.layer.borderColor = UIColor.lightGray.cgColor
        futureTableView.layer.borderWidth = 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataForecast?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateFormatter = DateFormatter()
        let cell = tableView.dequeueReusableCell(withIdentifier: "futureCell", for: indexPath) as! FutureCell
        cell.dayMaxTemp.text = String(Int(round(weatherDataForecast![indexPath.row].temperature?.max?.value ?? 99))) + "°"
        cell.dayMinTemp.text = String(Int(round(weatherDataForecast![indexPath.row].temperature?.min?.value ?? 99))) + "°"
        cell.dayOfWeek.text = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: weatherDataForecast![indexPath.row].time) - 1]
        cell.dayPrecipitation.text = String(weatherDataForecast![indexPath.row].precipitation?.probability?.value ?? 99) + "%"
        
        // Invert FutureVC colors during night time
        if dayTimeFromNowVC ?? true {
            self.view.backgroundColor = .white
            futureCityLabel.textColor = .black
            futureTableView.backgroundColor = .white
            cell.dayMaxTemp.textColor = .black
            cell.dayPrecipitation.textColor = .black
            cell.dayOfWeek.textColor = .black
            cell.backgroundColor = .white
            cell.dayWeatherIcon.image = UIImage(named: weatherDataForecast![indexPath.row].icon!)
            cell.umbrellaIcon.image = UIImage(named: "umbrella")
            nowButton.setTitleColor(.black, for: .normal)
        } else {
            self.view.backgroundColor = .black
            futureCityLabel.textColor = .white
            futureTableView.backgroundColor = .black
            cell.dayMaxTemp.textColor = .white
            cell.dayPrecipitation.textColor = .white
            cell.dayOfWeek.textColor = .white
            cell.backgroundColor = .black
            cell.dayWeatherIcon.image = invertImageColors(weatherIcon: UIImage(named: weatherDataForecast![indexPath.row].icon!)!)
            cell.umbrellaIcon.image = invertImageColors(weatherIcon: UIImage(named: "umbrella")!)
            nowButton.setTitleColor(.white, for: .normal)
        }
        print(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: weatherDataForecast![indexPath.row].time) - 1], weatherDataForecast![indexPath.row].time)
        return cell
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
