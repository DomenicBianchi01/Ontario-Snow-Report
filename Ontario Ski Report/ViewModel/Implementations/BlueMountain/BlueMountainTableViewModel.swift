//
//  BlueMountainTableViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-17.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainTableViewModel {}

extension BlueMountainTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        if blueMountainReport == nil {
            return 1
        }
        return 8
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return blueMountainReport?.mountainAreas.flatMap({ $0.lifts }).count ?? 0
        } else if section >= 3 {
            return blueMountainReport?.mountainAreas.map({ $0.trails })[section-3].count ?? 0
        }
        return 0
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var reuseID = ""
        
        if indexPath.section == 0 {
            reuseID = "OverviewReuseIdentifier"
        } else if indexPath.section == 1 && indexPath.row == 0 {
            reuseID = "WeatherReuseIdentifier"
        } else if indexPath.section == 1 && indexPath.row == 1 {
            reuseID = "SnowConditionsReuseIdentifier"
        } else if indexPath.section == 1 && indexPath.row == 2 {
            reuseID = "SnowfallHistoryReuseIdentifier"
        } else if indexPath.section == 2 {
            reuseID = "LiftStatusReuseIdentifier"
        } else {
            reuseID = "RunStatusReuseIdentifier"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        if let liftCell = cell as? LiftStatusTableViewCell {
            liftCell.liftNumber = indexPath.row
        } else if let runCell = cell as? RunStatusTableViewCell {
            runCell.section = indexPath.section-3
            runCell.runNumber = indexPath.row
        }
        
        return cell
    }
    
    func heightForHeader(in section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 22
    }
    
    func header(for section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightForHeader(in: section)))
        let label = UILabel(frame: CGRect(x: 7, y: 0, width: UIScreen.main.bounds.size.width, height: heightForHeader(in: section)))
        view.backgroundColor = .darkGray
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        
        if section == 1 {
            label.text = "Conditions"
        } else if section == 2 {
            label.text = "Lifts"
        } else if section == 3 {
            label.text = "Orchard Runs"
        } else if section == 4 {
            label.text = "South Runs"
        } else if section == 5 {
            label.text = "Village Runs"
        } else if section == 6 {
            label.text = "Inn Runs"
        } else if section == 7 {
            label.text = "North Runs"
        }

        view.addSubview(label)
        return view
    }
}

extension BlueMountainTableViewModel: TitleViewModelable {
    var title: String {
        return "Blue Mountain"
    }
}
