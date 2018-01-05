//
//  TableViewModelable.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-17.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewModelable {
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func header(for section: Int) -> UIView?
    func titleForHeader(in section: Int) -> String
    func heightForHeader(in section: Int) -> CGFloat
    func cellForRow(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}

// MARK: - Default implementations
extension TableViewModelable {
    func titleForHeader(in section: Int) -> String {
        return ""
    }
    func header(for section: Int) -> UIView? {
        return nil
    }
    func heightForHeader(in section: Int) -> CGFloat {
        return 22
    }
}
