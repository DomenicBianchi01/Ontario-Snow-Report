//
//  TodayViewController.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import UIKit
import NotificationCenter

final class TodayViewController: UIViewController, NCWidgetProviding {
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    private var tableViewModel: TableViewModelable = TodayTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }

    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = tableView.contentSize
        } else {
            preferredContentSize = maxSize
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        TodayMountainInfoDataProvider().fetchMountainInfo {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                if #available(iOSApplicationExtension 10.0, *) {
                    self.widgetActiveDisplayModeDidChange(.expanded, withMaximumSize: self.tableView.contentSize)
                } else {
                    self.preferredContentSize = self.tableView.contentSize
                }
                completionHandler(NCUpdateResult.newData)
            }
        }
    }
}

extension TodayViewController: UITableViewDataSource {
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

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.extensionContext?.open(URL(string: "todaySkiReportBlue://")!, completionHandler: nil)
        } else if indexPath.row == 1 {
            self.extensionContext?.open(URL(string: "todaySkiReportLouis://")!, completionHandler: nil)
        } else if indexPath.row == 2 {
            self.extensionContext?.open(URL(string: "todaySkiReportHorseshoe://")!, completionHandler: nil)
        } else if indexPath.row == 3 {
            self.extensionContext?.open(URL(string: "todaySkiReportGlen://")!, completionHandler: nil)
        }
    }
}
