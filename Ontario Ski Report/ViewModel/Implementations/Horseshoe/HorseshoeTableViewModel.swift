//
//  HorseshoeTableViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-11-26.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class HorseshoeTableViewModel {}

extension HorseshoeTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        if parsedReport == nil {
            return 1
        }
        return 7
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            do {
                return try (mountainDetails?.get(4).getElementsByTag("td").array().count ?? 0) / 3
            } catch {
                return 0
            }
        } else {
            do {
                return try (mountainDetails?.get(section-3).getElementsByTag("td").array().count ?? 0) / 3
            } catch {
                return 0
            }
        }
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var reuseID = ""
        
        if indexPath.section == 0 {
            reuseID = "OverviewReuseIdentifier"
        } else if indexPath.section == 1 && indexPath.row == 0 {
            reuseID = "SnowConditionsReuseIdentifier"
        } else if indexPath.section == 1 {
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
            runCell.section = indexPath.section-2
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
            label.text = "Chair Lifts"
        } else if section == 3 {
            label.text = "Easy"
        } else if section == 4 {
            label.text = "Difficult"
        } else if section == 5 {
            label.text = "Advanced"
        } else if section == 6 {
            label.text = "Expert"
        }
        
        view.addSubview(label)
        return view
    }
}

extension HorseshoeTableViewModel: TitleViewModelable {
    var title: String {
        return "Horseshoe Valley"
    }
}
