//
//  SnowConditionsTableViewCell.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-14.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class SnowConditionsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var snowConditionsLabel: UILabel!

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
        if selectedMountain == .blueMountain {
            snowConditionsLabel.text = BlueMountainSnowConditionsViewModel().description
        } else if selectedMountain == .horseshoe {
            snowConditionsLabel.text = HorseshoeSnowConditionsViewModel().description
        } else {
            snowConditionsLabel.text = GlenEdenSnowConditionsViewModel().description
        }
    }
}
