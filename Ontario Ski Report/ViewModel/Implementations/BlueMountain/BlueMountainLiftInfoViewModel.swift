//
//  BlueMountainLiftInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-18.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainLiftInfoViewModel {
    // MARK: - Properties
    private var lift: BlueLift?
    
    // MARK: - Lifecycle Functions
    init(for liftNumber: Int) {
        self.lift = blueMountainReport?.mountainAreas.flatMap({ $0.lifts })[liftNumber]
    }
}

extension BlueMountainLiftInfoViewModel: TitleViewModelable {
    var title: String {
        return lift?.name ?? "Unknown"
    }
}

extension BlueMountainLiftInfoViewModel: DescriptionViewModelable {
    var description: String {
        guard let lift = lift else {
            return "Unknown"
        }
        if lift.status.lowercased() == "open" {
            let weekday = Calendar.current.component(.weekday, from: Date())-1
            let values = Array(lift.hours.values)
            if let start = values[weekday].first?.value, let end = values[weekday].first(where: { $0.key == "Close" }) {
                return start + " - " + end.value
            }
            return "Unknown"
        } else {
            return "Closed"
        }
    }
}

extension BlueMountainLiftInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        if lift?.status.lowercased() == "open" {
            return [#imageLiteral(resourceName: "Checkmark")]
        } else {
            return [#imageLiteral(resourceName: "X")]
        }
    }
}
