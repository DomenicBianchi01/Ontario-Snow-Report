//
//  LiftStatusTableViewCell.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-14.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class LiftStatusTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var liftNameLabel: UILabel!
    @IBOutlet var liftOperatingHoursLabel: UILabel!
    
    // MARK: - Properties
    var liftNumber: Int = 0 {
        didSet {
            configure()
        }
    }
    
    // MARK: - Helper Functions
    private func configure() {
        switch selectedMountain {
        case .blueMountain:
            let viewModel = BlueMountainLiftInfoViewModel(for: liftNumber)
            let images = viewModel.images
            liftNameLabel.text = viewModel.title
            liftOperatingHoursLabel.text = viewModel.description
            statusImageView.image = images.first
        case .saintLouis:
            let viewModel = MountStLouisLiftInfoViewModel(for: liftNumber)
            let images = viewModel.images
            liftNameLabel.text = viewModel.title
            liftOperatingHoursLabel.text = viewModel.description
            statusImageView.image = images.first
        case .horseshoe:
            let viewModel = HorseshoeLiftInfoViewModel(for: liftNumber)
            let images = viewModel.images
            liftNameLabel.text = viewModel.title
            liftOperatingHoursLabel.text = viewModel.description
            statusImageView.image = images.first
        case .glenEden:
            let viewModel = GlenEdenLiftInfoViewModel(for: liftNumber)
            let images = viewModel.images
            liftNameLabel.text = viewModel.title
            liftOperatingHoursLabel.text = viewModel.description
            statusImageView.image = images.first
        }
    }
}
