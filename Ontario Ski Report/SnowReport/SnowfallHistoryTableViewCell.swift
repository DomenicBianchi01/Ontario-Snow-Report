//
//  SnowfallHistoryTableViewCell.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-11.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit

//TODO: Refactor to use view models
final class SnowfallHistoryTableViewCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet var overnightSnowfallLabel: UILabel!
    @IBOutlet var overnightLabel: UILabel!
    @IBOutlet var daySnowfallLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var twoDaysSnowfallLabel: UILabel!
    @IBOutlet var twoDaysLabel: UILabel!
    @IBOutlet var weekSnowfallLabel: UILabel!
    @IBOutlet var weekLabel: UILabel!
    @IBOutlet var leftDivider: UIView!
    @IBOutlet var rightDivider: UIView!
    
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
        if selectedMountain == .blueMountain {
            overnightLabel.text = "Overnight"
            dayLabel.text = "24hr"
            twoDaysLabel.text = "48hr"
            weekLabel.text = "7 Days"
            
            overnightLabel.isHidden = false
            overnightSnowfallLabel.isHidden = false
            weekLabel.isHidden = false
            weekSnowfallLabel.isHidden = false
            leftDivider.isHidden = false
            rightDivider.isHidden = false
            
            overnightSnowfallLabel.text = (blueMountainReport?.snowReport.baseArea["SinceLiftsClosedCm", default: ""] ?? "") + "cm"
            daySnowfallLabel.text = (blueMountainReport?.snowReport.baseArea["Last24HoursCm", default: ""] ?? "") + "cm"
            twoDaysSnowfallLabel.text = (blueMountainReport?.snowReport.baseArea["Last48HoursCm", default: ""] ?? "") + "cm"
            weekSnowfallLabel.text = (blueMountainReport?.snowReport.baseArea["Last7DaysCm", default: ""] ?? "") + "cm"
        } else {
            dayLabel.text = "24hr"
            twoDaysLabel.text = "Base"
            
            overnightLabel.isHidden = true
            overnightSnowfallLabel.isHidden = true
            weekLabel.isHidden = true
            weekSnowfallLabel.isHidden = true
            leftDivider.isHidden = true
            rightDivider.isHidden = true

            do {
                var data: String? = nil
                var data2: String? = nil
                
                if selectedMountain == .glenEden {
                    let conditions = try mountainDetails?.get(0).getElementsByTag("td")
                    
                    data = try conditions?.get(2).text()
                    data2 = try conditions?.get(1).text()
                } else {
                    data = try parsedReport?.getElementsByClass("data").last()?.text()
                    data2 = try parsedReport?.getElementsByTag("dd").get(2).text()
                }
                
                if let data = data, !data.isEmpty && Int(data) != nil {
                    daySnowfallLabel.text = data + " cm"
                } else {
                    daySnowfallLabel.text = "N/A"
                }
                
                if let data2 = data2, !data2.isEmpty && Int(data2) != nil {
                    twoDaysSnowfallLabel.text = data2
                } else {
                    twoDaysSnowfallLabel.text = "N/A"
                }
            } catch {
                daySnowfallLabel.text = "N/A"
                twoDaysSnowfallLabel.text = "N/A"
            }
        }
    }
}
