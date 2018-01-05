//
//  TodayGlenEdenViewModel.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TodayGlenEdenViewModel {}

extension TodayGlenEdenViewModel: TitleViewModelable {
    var title: String {
        return "Glen Eden"
    }
}

extension TodayGlenEdenViewModel: DescriptionViewModelable {
    var description: String {
        var openTrailCount = 0
        var totalTrailCount = 0
        var openTerrainParkCount = 0
        var totalTerrainParkCount = 0
        do {
            let trails = try glenEdenDetails?.get(2).getElementsByTag("td").filter({ !$0.hasAttr("colspan") })
            totalTrailCount = (trails?.count ?? 0) / 3
            openTrailCount = try trails?.filter({ try $0.text().lowercased() == "open" }).count ?? 0
            
            for index in 0 ..< (trails?.count ?? 0) {
                if try trails?[index].text().lowercased().contains("freestyle") ?? false {
                    totalTerrainParkCount += 1
                    if try trails?[index-2].text().lowercased() == "open" {
                        openTerrainParkCount += 1
                    }
                }
            }
            
            return """
            \(openTrailCount) of \(totalTrailCount) trails open
            \(openTerrainParkCount) of \(totalTerrainParkCount) terrain parks open
            New Snow: \(try glenEdenDetails?.get(0).getElementsByTag("td").get(2).text() ?? "-") cm
            """
        } catch {
            return "Unable to fetch data"
        }
    }
}
