//
//  GlenEdenInfoViewModel.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class GlenEdenInfoViewModel {
    // MARK: - Properties
    private var totalTrailCount = 0
    private var totalTerrainParkCount = 0
    private var openTrailCount = 0
    private var openTerrainParkCount = 0
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            let trails = try mountainDetails?.get(2).getElementsByTag("td").filter({ !$0.hasAttr("colspan") })
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
        } catch {}
    }
}

extension GlenEdenInfoViewModel: CounterViewModelable {
    var counters: [Int] {
        do {
            return [openTrailCount, openTerrainParkCount, Int(try mountainDetails?.get(0).getElementsByTag("td").get(2).text() ?? "-") ?? 0]
        } catch {
            return []
        }
    }
}

extension GlenEdenInfoViewModel: DescriptionsViewModelable {
    var descriptions: [String] {
        return ["of \(totalTrailCount) trails open", "of \(totalTerrainParkCount) terrain parks open", "cm of new snow"]
    }
}
