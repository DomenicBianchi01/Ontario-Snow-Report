//
//  GlenEdenSnowConditionsViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class GlenEdenSnowConditionsViewModel {}

extension GlenEdenSnowConditionsViewModel: DescriptionViewModelable {
    var description: String {
        do {
            return try mountainDetails?.get(0).getElementsByTag("td").first()?.text() ?? "Unknown"
        } catch {
            return "Unknown"
        }
    }
}
