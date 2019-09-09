//
//  FavoritesViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 02/09/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import CoreLocation

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        roundBorder(button: addButtonLabel)
    }
    
    // MARK: - Constants and Variables
    // Constants:
    let geoCoder = CLGeocoder()
    
    // Variables
    var favorites = [String]()
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var addButtonLabel: UIButton!
    
    // MARK: - Buttons
    // Navigation buttons appearance
    func roundBorder(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        if self.view.backgroundColor == UIColor.white {
            button.layer.borderColor = UIColor.black.cgColor
        } else {
            button.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // Buttons actions
    // Add city to favorites
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var cityNameTextField = UITextField()
        let alert = UIAlertController(title: "Enter city name", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            if cityNameTextField.text != "" {
                self.getLocation(forPlaceCalled: cityNameTextField.text!) { (location) in
                    print("User enters location: \(cityNameTextField.text!): \(location!)")
//                    self.weatherDataModel.currentCity = cityNameTextField.text!
//                    self.weatherDataModel.currentLocation = location
//                    self.getWeatherData(atLocation: location!)
                }
            }
        }
        let currentLocationAction = UIAlertAction(title: "Current Location", style: .default) { (alertAction) in
            print("Back to NowVC with Current Location")
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField { (textField) in
            cityNameTextField = textField
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addAction(currentLocationAction)
        alert.preferredAction = alert.actions[0]
        present(alert, animated: true, completion: nil)
    }
    
    
}

// MARK: - Convert coordinates to city names and back - - thanks to https://github.com/davidseek/Swift101ConvertCoordinates
extension FavoritesViewController: CLLocationManagerDelegate {
    
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
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView methods
    
    // Setup and configure tableview
    func configureTableView() {
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.separatorStyle = .none
        favoritesTableView.layer.masksToBounds = true
        favoritesTableView.layer.borderColor = UIColor.lightGray.cgColor
        favoritesTableView.layer.borderWidth = 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        cell.textLabel?.text = "City1"
        return cell
    }
    
    
}

