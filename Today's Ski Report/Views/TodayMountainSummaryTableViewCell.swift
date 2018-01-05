//
//  TodayMountainSummaryTableViewCell.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class TodayMountainSummaryTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var mountainNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var mountain: Mountain = .blueMountain {
        didSet {
            configure()
        }
    }

    // MARK: Helper Functions
    private func configure() {
        if #available(iOS 10, *) {
            mountainNameLabel.textColor = .black
            descriptionLabel.textColor = .black
        } else {
            mountainNameLabel.textColor = .white
            descriptionLabel.textColor = .white
        }

        switch mountain {
        case .blueMountain:
            let viewModel = TodayBlueMountainViewModel()
            mountainNameLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
        case .saintLouis:
            let viewModel = TodayMountStLouisViewModel()
            mountainNameLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
        case .horseshoe:
            let viewModel = TodayHorseshoeViewModel()
            mountainNameLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
        case .glenEden:
            let viewModel = TodayGlenEdenViewModel()
            mountainNameLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
        }
    }
}
