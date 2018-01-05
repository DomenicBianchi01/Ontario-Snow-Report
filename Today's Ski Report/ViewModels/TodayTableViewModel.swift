//
//  TodayTableViewModel.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import UIKit

final class TodayTableViewModel {}

extension TodayTableViewModel: TableViewModelable {
    var numberOfSections: Int {
        if blueMountainReport == nil {
            return 0
        }
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 4
    }
    
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MountainSummaryReuseIdentifier", for: indexPath)
        
        if let mountainCell = cell as? TodayMountainSummaryTableViewCell {
            mountainCell.mountain = Mountain(rawValue: indexPath.row) ?? .blueMountain
        }
        
        return cell
    }
}
