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
        configureTableView()
    }
    
    // MARK: - Variables
    var weatherDataForecast: [DataPoint]?
    @IBOutlet weak var futureTableView: UITableView!
    
    // MARK: - Button action - dismiss FutureVC and go back to NowVC
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
        cell.dayWeatherIcon.image = UIImage(named: weatherDataForecast![indexPath.row].icon!)
        cell.dayPrecipitation.text = String(weatherDataForecast![indexPath.row].precipitation?.probability?.value ?? 99) + "%"
        print(dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: weatherDataForecast![indexPath.row].time) - 1], weatherDataForecast![indexPath.row].time)
        return cell
    }
}
