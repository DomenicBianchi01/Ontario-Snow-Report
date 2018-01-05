//
//  GlenEdenTableViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class GlenEdenTableViewModel {}

extension GlenEdenTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        if parsedReport == nil {
            return 1
        }
        return 3
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 && parsedReport == nil {
            return 1
        } else if section == 0 {
            return 2
        } else if section == 1 {
            do {
                return try (mountainDetails?.get(3).getElementsByTag("td").filter({ !$0.hasAttr("colspan") }).count ?? 0) / 3
            } catch {
                return 0
            }
        } else if section == 2 {
            do {
                return try (mountainDetails?.get(2).getElementsByTag("td").filter({ !$0.hasAttr("colspan") }).count ?? 0) / 3
            } catch {
                return 0
            }
        }
        return 0
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var reuseID = ""
        
        if indexPath.section == 0 && parsedReport == nil {
            reuseID = "OverviewReuseIdentifier"
        } else if indexPath.section == 0 && indexPath.row == 0 {
            reuseID = "SnowConditionsReuseIdentifier"
        } else if indexPath.section == 0 {
            reuseID = "SnowfallHistoryReuseIdentifier"
        } else if indexPath.section == 1 {
            reuseID = "LiftStatusReuseIdentifier"
        } else {
            reuseID = "RunStatusReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        if let liftCell = cell as? LiftStatusTableViewCell {
            liftCell.liftNumber = indexPath.row
        } else if let runCell = cell as? RunStatusTableViewCell {
            runCell.runNumber = indexPath.row
        }
        return cell
    }
    
    func heightForHeader(in section: Int) -> CGFloat {
        if parsedReport == nil {
            return 0
        }
        return 22
    }
    
    func header(for section: Int) -> UIView? {
        if parsedReport == nil {
            return nil
        }
        
        let headerHeight = heightForHeader(in: section)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: headerHeight))
        let label = UILabel(frame: CGRect(x: 7, y: 0, width: UIScreen.main.bounds.size.width, height: headerHeight))
        view.backgroundColor = .darkGray
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        
        if section == 0 {
            label.text = "Conditions"
        } else if section == 1 {
            label.text = "Lifts"
        } else if section == 2 {
            label.text = "Runs"
        }
        
        view.addSubview(label)
        return view
    }
}

extension GlenEdenTableViewModel: TitleViewModelable {
    var title: String {
        return "Glen Eden"
    }
}
