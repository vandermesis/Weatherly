//
//  PastViewController.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 24/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit

class PastViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var cityFromNowVC: String?
    
    @IBOutlet weak var pastTempLabel: UILabel!
    @IBOutlet weak var pastWeatherIcon: UIImageView!
    @IBOutlet weak var pastCityLabel: UILabel!
    
    @IBAction func pastDatePickerChanged(_ sender: UIDatePicker) {
    }
    
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
