//
//  BlueMountainSnowConditionsViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainSnowConditionsViewModel {}

extension BlueMountainSnowConditionsViewModel: DescriptionViewModelable {
    var description: String {
        return blueMountainReport?.snowReport.baseConditions ?? "Unknown"
    }
}
