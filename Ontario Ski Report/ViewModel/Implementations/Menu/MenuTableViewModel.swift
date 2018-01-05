//
//  MenuTableViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-19.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

final class MenuTableViewModel {}

extension MenuTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 4
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemReuseIdentifier", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Blue Mountain"
        case 1:
            cell.textLabel?.text = "Mt. St. Louis Moonstone"
        case 2:
            cell.textLabel?.text = "Horseshoe Valley"
        case 3:
            cell.textLabel?.text = "Glen Eden"
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }
}
