//
//  MountStLouisTableViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-19.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class MountStLouisTableViewModel {}

extension MountStLouisTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        if parsedReport == nil {
            return 1
        }
        return 5
    }
    
    func numberOfRows(in section: Int) -> Int {
        if section == 0 && parsedReport == nil {
            return 1
        } else if section == 0 || section == 1 {
            do {
                return try mountainDetails?.array()[section+2].select(".status").array().count ?? 0
            } catch {
                return 0
            }
        } else if section == 2 || section == 3 {
            do {
                return try mountainDetails?.array()[section-2].select(".status").array().count ?? 0
            } catch {
                return 0
            }
        } else if section == 4 {
            return 3
        }
        return 0
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var reuseID = ""
        
        if indexPath.section == 0 && parsedReport == nil {
            reuseID = "OverviewReuseIdentifier"
        } else if indexPath.section == 0 || indexPath.section == 1 {
            reuseID = "LiftStatusReuseIdentifier"
        } else {
            reuseID = "RunStatusReuseIdentifier"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        if let liftCell = cell as? LiftStatusTableViewCell {
            if indexPath.section == 1 {
                liftCell.liftNumber = indexPath.row + numberOfRows(in: 0)
            } else {
                liftCell.liftNumber = indexPath.row
            }
        } else if let runCell = cell as? RunStatusTableViewCell {
            if indexPath.section == 2 {
                runCell.runNumber = indexPath.row
            } else if indexPath.section == 3 {
                runCell.runNumber = indexPath.row + numberOfRows(in: 2)
            } else {
                runCell.runNumber = indexPath.row + numberOfRows(in: 2) + numberOfRows(in: 3)
            }
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
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heightForHeader(in: section)))
        let label = UILabel(frame: CGRect(x: 7, y: 0, width: UIScreen.main.bounds.size.width, height: heightForHeader(in: section)))
        view.backgroundColor = .darkGray
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textColor = .white
        
        if section == 0 {
            do {
                label.text = try mountainDetails?.array()[2].siblingElements().array().first?.text()
            } catch {}
        } else if section == 1 {
            do {
                label.text = try mountainDetails?.array()[3].siblingElements().array().first?.text()
            } catch {}
        } else if section == 2 {
            do {
                label.text = try mountainDetails?.array()[0].siblingElements().array().first?.text()
            } catch {}
        } else if section == 3 {
            do {
                label.text = try mountainDetails?.array()[1].siblingElements().array().first?.text()
            } catch {}
        } else if section == 4 {
            label.text = "Terrain Parks"
        }
        
        view.addSubview(label)
        return view
    }
}

extension MountStLouisTableViewModel: TitleViewModelable {
    var title: String {
        return "Mt. St. Louis Moonstone"
    }
}
