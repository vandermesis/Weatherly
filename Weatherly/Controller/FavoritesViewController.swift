//
//  FavoritesViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 02/09/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

protocol CanReceive {
    func userEntered(city: String)
    func setFavorites(mode: Bool)
}

class FavoritesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        roundBorder(button: addButtonLabel)
        loadCities()
        print("Favorites before OK: \(favorites.count)")
    }
    
    // MARK: - Constants and Variables
    // Constants:
    let geoCoder = CLGeocoder()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Variables
    var delegate: CanReceive?
    var favorites = [Favorites]()
    var dayTimeFromNowVC: Bool?
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var addButtonLabel: UIButton!
    
    // MARK: - Buttons
    // Navigation buttons appearance
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
    
    // Buttons actions
    // Add city to favorites
    @IBAction func addButtonPressed(_ sender: UIButton) {
        var cityNameTextField = UITextField()
        let alert = UIAlertController(title: "Enter city name", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            if cityNameTextField.text != "" {
                    let newCity = Favorites(context: self.context)
                    newCity.city = cityNameTextField.text
                    self.favorites.append(newCity)
                    self.saveCities()
                    self.favoritesTableView.reloadData()
                    self.delegate?.userEntered(city: cityNameTextField.text!)
                    self.dismiss(animated: true, completion: nil)
            }
        }
        let currentLocationAction = UIAlertAction(title: "Current Location", style: .default) { (alertAction) in
            print("Back to NowVC with Current Location")
            self.delegate?.setFavorites(mode: false)
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
        print("Favorites after OK: \(favorites.count)")
    }
    
    //MARK: - CRUD - Save and Load user favorite cities with CoreData
    // Read data from database
    func loadCities() {
        let request: NSFetchRequest<Favorites> = Favorites.fetchRequest()
        do {
            favorites = try context.fetch(request)
        } catch {
            print("Error fetching cities: \(error.localizedDescription)")
        }
        favoritesTableView.reloadData()
    }
    
    // Save data to database
    func saveCities() {
        do {
            try context.save()
        } catch {
            print("Error saving cities \(error)")
        }
    }
}

// MARK: - TableView methods
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        cell.textLabel?.text = favorites[indexPath.row].city
        
        // Invert FutureVC colors during night time
        if dayTimeFromNowVC ?? true {
            self.view.backgroundColor = .white
            favoritesTableView.backgroundColor = .white
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
            addButtonLabel.setTitleColor(.black, for: .normal)
        } else {
            self.view.backgroundColor = .black
            favoritesTableView.backgroundColor = .black
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .black
            addButtonLabel.setTitleColor(.white, for: .normal)
        }
        
        return cell
    }

    // Select city from favorites and go to NowVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favorites[indexPath.row])
        if let selectedCity = favorites[indexPath.row].city {
            delegate?.userEntered(city: selectedCity)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Remove city from favorites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(favorites[indexPath.row])
            do {
                try context.save()
            } catch {
                print("Error context.save: \(error)")
            }
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

