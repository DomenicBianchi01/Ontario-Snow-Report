//
//  MountStLouisRunInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-23.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class MountStLouisRunInfoViewModel {
    // MARK: - Properties
    private var trailName: String?
    private var trailStatus: String?
    private var trailDifficulty: String?
    
    // MARK: - Lifecycle Functions
    init(for trailDifficulty: TrailDifficulty, and runNumber: Int) {
        do {
            let louisTrails = try mountainDetails?.get(0).select(".title").array()
            let moonstoneTrails = try mountainDetails?.get(1).select(".title").array()
            let louisTrailCount = louisTrails?.count ?? 0
            let moonstoneTrailCount = moonstoneTrails?.count ?? 0
            if runNumber >= louisTrailCount + moonstoneTrailCount {
                let runNumber = runNumber - louisTrailCount - moonstoneTrailCount
                let sectionInfo = mountainDetails?.get(4+runNumber)
                self.trailName = try sectionInfo?.select(".title").first()?.text()
                self.trailStatus = try sectionInfo?.select(".status").first()?.text()
                self.trailDifficulty = "terrain-park"
            } else if runNumber < louisTrailCount {
                self.trailName = try louisTrails?[runNumber].text()
                self.trailStatus = try mountainDetails?.get(0).select(".status").get(runNumber).text()
                self.trailDifficulty = try mountainDetails?.get(0).select("img[src]").get(runNumber).attr("src").description
            } else {
                self.trailName = try mountainDetails?.get(1).select(".title").get(runNumber-louisTrailCount).text()
                self.trailStatus = try mountainDetails?.get(1).select(".status").get(runNumber-louisTrailCount).text()
                self.trailDifficulty = try mountainDetails?.get(1).select("img[src]").get(runNumber-louisTrailCount).attr("src").description
            }
        } catch {}
    }
}

extension MountStLouisRunInfoViewModel: TitleViewModelable {
    var title: String {
        return trailName ?? "Unknown"
    }
}

extension MountStLouisRunInfoViewModel: DescriptionViewModelable {
    var description: String {
        return trailStatus ?? "Unknown"
    }
}

extension MountStLouisRunInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        var difficultyImage = UIImage()
        if trailDifficulty?.contains("easy") ?? false {
            difficultyImage = #imageLiteral(resourceName: "Green Circle")
        } else if trailDifficulty?.contains("more-difficult") ?? false {
            difficultyImage = #imageLiteral(resourceName: "Blue Square")
        } else if trailDifficulty?.contains("most-difficult") ?? false {
            difficultyImage = #imageLiteral(resourceName: "Black Diamond")
        } else if trailDifficulty == "terrain-park" {
            difficultyImage = #imageLiteral(resourceName: "Terrain Park")
        }
        
        if trailStatus?.lowercased() == "open" {
            return [difficultyImage, #imageLiteral(resourceName: "Checkmark")]
        } else {
            return [difficultyImage, #imageLiteral(resourceName: "X")]
        }
    }
}
