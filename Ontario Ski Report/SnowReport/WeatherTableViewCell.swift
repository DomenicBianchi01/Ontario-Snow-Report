//
//  WeatherTableViewCell.swift
//  Ontario Snow Report
//
//  Created by Domenic Bianchi on 2017-11-18.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
    
    // MARK: Helper Functions
    private func configure() {
        if let base = blueMountainReport?.currentConditions["Base"] {
            temperatureLabel.text = ((base["TemperatureC"]?.value as? String) ?? "Unknown") + "°C"
            weatherLabel.text = (base["Skies"]?.value as? String) ?? "Unknown"
        } else {
            temperatureLabel.text = "Unknown"
            weatherLabel.text = "Unknown"
        }
    }
}
