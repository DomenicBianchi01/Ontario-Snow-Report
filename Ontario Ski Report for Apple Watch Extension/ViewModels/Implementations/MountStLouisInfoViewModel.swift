//
//  MountStLouisInfoViewModel.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class MountStLouisInfoViewModel {
    // MARK: - Properties
    private var totalTrailCount = 0
    private var openTrailCount = 0
    private var openTerrainParkCount = 0
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            totalTrailCount = try (mountainDetails?.get(0).select(".title").array().count ?? 0) + (mountainDetails?.get(1).select(".title").array().count ?? 0)
            
            openTrailCount = try (mountainDetails?.get(0).select(".status").filter({ try $0.text().lowercased() == "open" }).count ?? 0) + (mountainDetails?.get(1).select(".status").filter({ try $0.text().lowercased() == "open" }).count ?? 0)
            
            openTerrainParkCount = try (mountainDetails?.get(4).select(".status").text().lowercased() == "open" ? 1 : 0) + (mountainDetails?.get(5).select(".status").text().lowercased() == "open" ? 1 : 0) + (mountainDetails?.get(6).select(".status").text().lowercased() == "open" ? 1 : 0)
        } catch {}
    }
}

extension MountStLouisInfoViewModel: CounterViewModelable {
    var counters: [Int] {
        return [openTrailCount, openTerrainParkCount]
    }
}

extension MountStLouisInfoViewModel: DescriptionsViewModelable {
    var descriptions: [String] {
        return ["of \(totalTrailCount) trails open", "of 3 terrain parks open", "cm of new snow"]
    }
}
