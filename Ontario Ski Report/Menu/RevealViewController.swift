//
//  RevealViewController.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2016-10-14.
//  Copyright © 2016 Domenic Bianchi. All rights reserved.
//

import UIKit

final class RevealViewController: UIViewController {
    // MARK: - Properties
    private var tableViewModel: TableViewModelable!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewModel = MenuTableViewModel()
    }
}

extension RevealViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewModel.cellForRow(in: tableView, at: indexPath)
    }
}

extension RevealViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMountain = Mountain(rawValue: indexPath.row) ?? .blueMountain
    }
}
