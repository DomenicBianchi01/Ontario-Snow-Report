//
//  TodayBlueMountainViewModel.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TodayBlueMountainViewModel {}

extension TodayBlueMountainViewModel: TitleViewModelable {
    var title: String {
        return "Blue Mountain"
    }
}

extension TodayBlueMountainViewModel: DescriptionViewModelable {
    var description: String {
        var openTrailCount = 0
        var totalTrailCount = 0
        var openTerrainParkCount = 0
        var totalTerrainParkCount = 0
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
        
        return """
        \(openTrailCount) of \(totalTrailCount) trails open
        \(openTerrainParkCount) of \(totalTerrainParkCount) terrain parks open
        New Snow: \(blueMountainReport?.snowReport.baseArea["SinceLiftsClosedCm"] ?? "") cm
        """
    }
}
