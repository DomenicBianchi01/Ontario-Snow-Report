//
//  TodayMountStLouisViewModel.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TodayMountStLouisViewModel {}

extension TodayMountStLouisViewModel: TitleViewModelable {
    var title: String {
        return "Mt. St. Louis Moonstone"
    }
}

extension TodayMountStLouisViewModel: DescriptionViewModelable {
    var description: String {
        var openTrailCount = 0
        var totalTrailCount = 0
        var openTerrainParkCount = 0
        do {
            totalTrailCount = try (mtSaintLouisDetails?.get(0).select(".title").array().count ?? 0) + (mtSaintLouisDetails?.get(1).select(".title").array().count ?? 0)
            
            openTrailCount = try (mtSaintLouisDetails?.get(0).select(".status").filter({ try $0.text().lowercased() == "open" }).count ?? 0) + (mtSaintLouisDetails?.get(1).select(".status").filter({ try $0.text().lowercased() == "open" }).count ?? 0)
            
            openTerrainParkCount = try (mtSaintLouisDetails?.get(4).select(".status").text().lowercased() == "open" ? 1 : 0) + (mtSaintLouisDetails?.get(5).select(".status").text().lowercased() == "open" ? 1 : 0) + (mtSaintLouisDetails?.get(6).select(".status").text().lowercased() == "open" ? 1 : 0)
        } catch {}
        
        return """
        \(openTrailCount) of \(totalTrailCount) trails open
        \(openTerrainParkCount) of 3 terrain parks open
        """
    }
}
