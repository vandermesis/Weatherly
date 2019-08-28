//
//  FutureCell.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 26/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit

class FutureCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Variables for connected outlets
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayMaxTemp: UILabel!
    @IBOutlet weak var dayMinTemp: UILabel!
    @IBOutlet weak var dayWeatherIcon: UIImageView!
    @IBOutlet weak var dayPrecipitation: UILabel!
}
