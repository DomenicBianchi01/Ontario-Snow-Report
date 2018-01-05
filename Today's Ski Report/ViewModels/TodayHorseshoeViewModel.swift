//
//  TodayHorseshoeViewModel.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TodayHorseshoeViewModel {}

extension TodayHorseshoeViewModel: TitleViewModelable {
    var title: String {
        return "Horseshoe Valley"
    }
}

extension TodayHorseshoeViewModel: DescriptionViewModelable {
    var description: String {
        var openTrailCount = 0
        var totalTrailCount = 0
        var openTerrainParkCount = 0
        var totalTerrainParkCount = 0
        do {
            for index in 0...3 {
                let trails = try horseshoeDetails?.get(index).getElementsByTag("td")
                totalTrailCount += (trails?.array().count ?? 0) / 3
                let statuses = try trails?.filter({ try $0.text().lowercased() == "open" || $0.text().lowercased() == "not available" }) ?? []
                openTrailCount += statuses.count / 2
            }
            let terrainParks = try horseshoeDetails?.get(5).getElementsByTag("td")
            totalTerrainParkCount = (terrainParks?.array().count ?? 0) / 3
            openTerrainParkCount = try (terrainParks?.filter({ try $0.text().lowercased() == "open" }).count ?? 0) / 2
            
            return """
            \(openTrailCount) of \(totalTrailCount) trails open
            \(openTerrainParkCount) of \(totalTerrainParkCount) terrain parks open
            New Snow: \(try horseshoeFullReport?.getElementsByClass("data").last()?.text() ?? "-") cm
            """
        } catch {
            return "Unable to fetch data"
        }
    }
}
