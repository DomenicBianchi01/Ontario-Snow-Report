//
//  LastUpdateTableViewCell.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-10.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

final class LastUpdateTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet var lastUpdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure()
    }
    
    // MARK: - Helper Functions
    private func configure() {
        if (parsedReport == nil && selectedMountain != .blueMountain) || (blueMountainReport == nil && selectedMountain == .blueMountain) {
            lastUpdateLabel.text = "No Internet Connection"
            return
        }
        
        if selectedMountain == .blueMountain, let lastUpdate = blueMountainReport?.lastUpdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from: lastUpdate) else {
                lastUpdateLabel.text = "Last Update Unknown"
                return
            }
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy @ h:mm a"
            lastUpdateLabel.text = dateFormatter.string(from: date)
        } else {
            do {
                lastUpdateLabel.text = try parsedReport?.getElementsByClass("updated").text()
            } catch {
                lastUpdateLabel.text = "Last Update Unknown"
            }
        }
    }
}
