//
//  SnowReportViewController.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2016-10-14.
//  Copyright © 2016 Domenic Bianchi. All rights reserved.
//

import UIKit
import Firebase

final class SnowReportViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var trailMapButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    private var tableViewModel: TableViewModelable? = nil
    private var dataLoaded: Bool = false
    private var isCancelled: Bool = false
    
    private let dispatchQueue = DispatchQueue(label: "fetchSnowReportData",
                                              qos: .userInitiated,
                                              attributes: [],
                                              autoreleaseFrequency: .inherit,
                                              target: nil)
    
    private var workItem: DispatchWorkItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(todayExtensionReloadReport), name:
            .todayExtensionMountainSelected, object: nil)
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadReport(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
        if #available(iOS 10, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        
        navigationItem.rightBarButtonItem = trailMapButton
        
        let mountainType: String
        
        if selectedMountain == .blueMountain {
            mountainType = "Blue Mountain"
        } else if selectedMountain == .saintLouis {
            mountainType = "Mt. St. Louis"
        } else if selectedMountain == .horseshoe {
            mountainType = "Horseshoe Valley"
        } else {
            mountainType = "Glen Eden"
        }
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterItemID: "id-\(mountainType)" as NSObject,
                                                                     AnalyticsParameterItemName: mountainType + " selected"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !dataLoaded {
            reloadReport()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        workItem?.cancel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func todayExtensionReloadReport() {
        tableViewModel = nil
        trailMapButton.isEnabled = false
        tableView.reloadData()
        activityIndicator.startAnimating()
        reloadReport()
    }
    
    @objc private func reloadReport(_ refreshControl: UIRefreshControl? = nil) {
        DispatchQueue.main.async {
            refreshControl?.beginRefreshing()
        }
        
        let dataProvider: MountainInfoDataProvidable
        
        switch selectedMountain {
        case .blueMountain:
            tableViewModel = BlueMountainTableViewModel()
            dataProvider = BlueMountainDataProvider()
        case .saintLouis:
            tableViewModel = MountStLouisTableViewModel()
            dataProvider = MountStLouisDataProvider()
        case .horseshoe:
            tableViewModel = HorseshoeTableViewModel()
            dataProvider = HorseshoeDataProvider()
        case .glenEden:
            tableViewModel = GlenEdenTableViewModel()
            dataProvider = GlenEdenDataProvider()
        }
        
        navigationItem.title = (tableViewModel as? TitleViewModelable)?.title ?? "Snow Report"
        
        workItem = DispatchWorkItem {
            dataProvider.fetchMountainInfo { [weak self] in
                DispatchQueue.main.async {
                    if refreshControl?.isRefreshing == true {
                        refreshControl?.endRefreshing()
                    }
                    if self?.isCancelled == true {
                        return
                    }
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
                    self?.dataLoaded = true
                    
                    if (parsedReport != nil && selectedMountain != .blueMountain) || (blueMountainReport != nil && selectedMountain == .blueMountain) {
                        self?.trailMapButton.isEnabled = true
                    }
                }
            }
        }
        if let workItem = workItem {
            dispatchQueue.async(execute: workItem)
        }
    }
}

extension SnowReportViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewModel?.cellForRow(in: tableView, at: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewModel?.header(for: section) ?? nil
    }
}

extension SnowReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewModel?.heightForHeader(in: section) ?? 44
    }
}
