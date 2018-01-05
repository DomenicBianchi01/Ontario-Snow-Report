//
//  HorseshoeInfoViewModel.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class HorseshoeInfoViewModel {
    // MARK: - Properties
    private var totalTrailCount = 0
    private var totalTerrainParkCount = 0
    private var openTrailCount = 0
    private var openTerrainParkCount = 0
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            for index in 0...3 {
                let trails = try mountainDetails?.get(index).getElementsByTag("td")
                totalTrailCount += (trails?.array().count ?? 0) / 3
                let statuses = try trails?.filter({ try $0.text().lowercased() == "open" || $0.text().lowercased() == "not available" }) ?? []
                openTrailCount += statuses.count / 2
            }
            let terrainParks = try mountainDetails?.get(5).getElementsByTag("td")
            totalTerrainParkCount = (terrainParks?.array().count ?? 0) / 3
            openTerrainParkCount = try (terrainParks?.filter({ try $0.text().lowercased() == "open" }).count ?? 0) / 2
        } catch {}
    }
}

extension HorseshoeInfoViewModel: CounterViewModelable {
    var counters: [Int] {
        do {
            return [openTrailCount, openTerrainParkCount, Int(try parsedReport?.getElementsByClass("data").last()?.text() ?? "-") ?? 0]
        } catch {
            return []
        }
    }
}

extension HorseshoeInfoViewModel: DescriptionsViewModelable {
    var descriptions: [String] {
        return ["of \(totalTrailCount) trails open", "of \(totalTerrainParkCount) terrain parks open", "cm of new snow"]
    }
}
