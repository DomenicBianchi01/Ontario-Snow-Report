//
//  HorseshoeSnowConditionsViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-27.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class HorseshoeSnowConditionsViewModel {}

extension HorseshoeSnowConditionsViewModel: DescriptionViewModelable {
    var description: String {
        do {
            return try parsedReport?.getElementsByTag("dd").get(1).text() ?? "Unknown"
        } catch {
            return "Unknown"
        }
    }
}
