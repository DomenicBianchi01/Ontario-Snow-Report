//
//  BlueMountainRunInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-17.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainRunInfoViewModel {
    // MARK: - Properties
    private var trail: BlueTrail?
    
    // MARK: - Lifecycle Functions
    init(for section: Int, and runNumber: Int) {
        self.trail = blueMountainReport?.mountainAreas.map({ $0.trails })[section][runNumber]
    }
}

extension BlueMountainRunInfoViewModel: TitleViewModelable {
    var title: String {
        return trail?.name ?? "Unknown"
    }
}

extension BlueMountainRunInfoViewModel: DescriptionViewModelable {
    var description: String {
        return trail?.status ?? "Unknown"
    }
}

extension BlueMountainRunInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        var difficultyImage: UIImage
        let difficulty = trail?.difficulty
        if difficulty == .largePark || difficulty == .mediumPark || difficulty == .smallPark {
            difficultyImage = #imageLiteral(resourceName: "Terrain Park")
        } else if difficulty == .easy {
            difficultyImage = #imageLiteral(resourceName: "Green Circle")
        } else if difficulty == .intermediate {
            difficultyImage = #imageLiteral(resourceName: "Blue Square")
        } else if difficulty == .advanced || difficulty == .advanced2 {
            difficultyImage = #imageLiteral(resourceName: "Black Diamond")
        } else if difficulty == .expert {
            difficultyImage = #imageLiteral(resourceName: "Double Black Diamond")
        } else {
            difficultyImage = UIImage()
        }
        
        if trail?.status == "Open" {
            return [difficultyImage, #imageLiteral(resourceName: "Checkmark")]
        } else {
            return [difficultyImage, #imageLiteral(resourceName: "X")]
        }
    }
}
