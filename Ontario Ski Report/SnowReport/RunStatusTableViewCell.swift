//
//  RunStatusTableViewCell.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-14.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class RunStatusTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var trailDifficultyImageView: UIImageView!
    @IBOutlet var runNameLabel: UILabel!
    @IBOutlet var runStatusLabel: UILabel!
    
    // MARK: - Properties
    var section = 0
    var runNumber: Int = 0 {
        didSet {
            configure()
        }
    }
    
    // MARK: - Helper Functions
    private func configure() {
        switch selectedMountain {
        case .blueMountain:
            let viewModel = BlueMountainRunInfoViewModel(for: section, and: runNumber)
            let images = viewModel.images
            runNameLabel.text = viewModel.title
            runStatusLabel.text = viewModel.description
            trailDifficultyImageView.image = images.first
            statusImageView.image = images.last
        case .saintLouis:
            let viewModel = MountStLouisRunInfoViewModel(for: .unknown, and: runNumber)
            let images = viewModel.images
            runNameLabel.text = viewModel.title
            runStatusLabel.text = viewModel.description
            trailDifficultyImageView.image = images.first
            statusImageView.image = images.last
        case .horseshoe:
            let viewModel = HorseshoeRunInfoViewModel(for: TrailDifficulty(rawValue: section) ?? .unknown, and: runNumber)
            let images = viewModel.images
            runNameLabel.text = viewModel.title
            runStatusLabel.text = viewModel.description
            trailDifficultyImageView.image = images.first
            statusImageView.image = images.last
        case .glenEden:
            let viewModel = GlenEdenRunInfoViewModel(for: .unknown, and: runNumber)
            let images = viewModel.images
            runNameLabel.text = viewModel.title
            runStatusLabel.text = viewModel.description
            trailDifficultyImageView.image = images.first
            statusImageView.image = images.last
        }
    }
}
