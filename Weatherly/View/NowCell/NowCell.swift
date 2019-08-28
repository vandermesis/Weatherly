//
//  NowCell.swift
//  Weatherly
//
//  Created by Marek Skrzelowski on 27/08/2019.
//  Copyright © 2019 vandermesis. All rights reserved.
//

import UIKit

class NowCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Variables for connected outlets
    @IBOutlet weak var nowHour: UILabel!
    @IBOutlet weak var nowWeatherIcon: UIImageView!
    @IBOutlet weak var nowTemperature: UILabel!
    @IBOutlet weak var nowPrecipitation: UILabel!
    
}
