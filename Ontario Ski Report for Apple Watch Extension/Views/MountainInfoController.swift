//
//  MountainInfoController.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import WatchKit

final class MountainInfoController: WKInterfaceController {
    // MARK: - IBOutlets
    @IBOutlet var mountainStatsTable: WKInterfaceTable!
    @IBOutlet var mountainName: WKInterfaceLabel!
    @IBOutlet var loadingLabel: WKInterfaceLabel!
    
    // MARK: - Properties
    private var selectedMountain: Mountain = .blueMountain
    private let dispatchQueue = DispatchQueue(label: "watch.fetchMountainInfo",
                                              qos: .userInitiated,
                                              attributes: [],
                                              autoreleaseFrequency: .inherit,
                                              target: nil)

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let selectedMountain = context as? Mountain else {
            loadingLabel.setText("Could not load data")
            return
        }
        
        self.selectedMountain = selectedMountain
        
        mountainStatsTable.setNumberOfRows(0, withRowType: "")
        
        switch selectedMountain {
        case .blueMountain:
            mountainName.setText("Blue Mountain")
            dispatchQueue.async {
                BlueMountainInfoDataProvider().fetchMountainInfo {
                    DispatchQueue.main.async {
                        let viewModel = BlueMountainInfoViewModel()
                        self.configureCells(numberOfRows: 3, counterViewModel: viewModel as CounterViewModelable, descriptionsViewModel: viewModel as DescriptionsViewModelable)
                    }
                }
            }
        case .saintLouis:
            mountainName.setText("Mt. St. Louis")
            dispatchQueue.async {
                MountStLouisInfoDataProvider().fetchMountainInfo {
                    DispatchQueue.main.async {
                        let viewModel = MountStLouisInfoViewModel()
                        self.configureCells(numberOfRows: 2, counterViewModel: viewModel as CounterViewModelable, descriptionsViewModel: viewModel as DescriptionsViewModelable)
                    }
                }
            }
        case .horseshoe:
            mountainName.setText("Horseshoe Valley")
            dispatchQueue.async {
                HorseshoeInfoDataProvider().fetchMountainInfo {
                    DispatchQueue.main.async {
                        let viewModel = HorseshoeInfoViewModel()
                        self.configureCells(numberOfRows: 3, counterViewModel: viewModel as CounterViewModelable, descriptionsViewModel: viewModel as DescriptionsViewModelable)
                    }
                }
            }
        case .glenEden:
            mountainName.setText("Glen Eden")
            dispatchQueue.async {
                GlenEdenInfoDataProvider().fetchMountainInfo {
                    DispatchQueue.main.async {
                        let viewModel = GlenEdenInfoViewModel()
                        self.configureCells(numberOfRows: 3, counterViewModel: viewModel as CounterViewModelable, descriptionsViewModel: viewModel as DescriptionsViewModelable)
                    }
                }
            }
        }
    }
    
    // MARK: Helper Functions
    private func configureCells(numberOfRows: Int, counterViewModel: CounterViewModelable, descriptionsViewModel: DescriptionsViewModelable) {
        
        mountainStatsTable.setNumberOfRows(numberOfRows, withRowType: "StatsRow")
        
        for index in 0 ..< numberOfRows {
            guard let controller = self.mountainStatsTable.rowController(at: index) as? MountainInfoRowController else { continue }
            
            controller.counterLabel.setText(String(counterViewModel.counters[index]))
            controller.descriptionLabel.setText(descriptionsViewModel.descriptions[index])
        }
        
        loadingLabel.setHidden(true)
    }
}
