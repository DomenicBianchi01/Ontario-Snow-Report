//
//  BlueMountainInfoViewModel.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainInfoViewModel {
    // MARK: - Properties
    private var totalTrailCount = 0
    private var totalTerrainParkCount = 0
    private var openTrailCount = 0
    private var openTerrainParkCount = 0
    
    // MARK: - Lifecycle Functions
    init() {
        for trails in blueMountainReport?.mountainAreas.map({ $0.trails }) ?? [] {
            for trail in trails.filter({ !$0.name.lowercased().contains("glade") }) {
                if trail.difficulty == .smallPark || trail.difficulty == .mediumPark || trail.difficulty == .largePark {
                    totalTerrainParkCount += 1
                    if trail.status.lowercased() == "open" {
                        openTerrainParkCount += 1
                    }
                    continue
                }
                totalTrailCount += 1
                if trail.status.lowercased() == "open" {
                    openTrailCount += 1
                }
            }
        }
    }
}

extension BlueMountainInfoViewModel: CounterViewModelable {
    var counters: [Int] {
        return [openTrailCount, openTerrainParkCount, Int(blueMountainReport?.snowReport.baseArea["SinceLiftsClosedCm", default: ""] ?? "") ?? 0]
    }
}

extension BlueMountainInfoViewModel: DescriptionsViewModelable {
    var descriptions: [String] {
        return ["of \(totalTrailCount) trails open", "of \(totalTerrainParkCount) terrain parks open", "cm of new snow"]
    }
}
