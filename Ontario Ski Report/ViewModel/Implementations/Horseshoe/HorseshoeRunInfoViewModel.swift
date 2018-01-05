//
//  HorseshoeRunInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-11-26.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class HorseshoeRunInfoViewModel {
    // MARK: - Properties
    private var run: Elements? = nil
    private var runNumber: Int
    private var trailDifficulty: TrailDifficulty
    
    // MARK: - Lifecycle Functions
    init(for trailDifficulty: TrailDifficulty, and runNumber: Int) {
        self.runNumber = runNumber * 3
        self.trailDifficulty = trailDifficulty
        do {
            self.run = try mountainDetails?.get(trailDifficulty.rawValue-1).getElementsByTag("td")
        } catch {}
    }
}

extension HorseshoeRunInfoViewModel: TitleViewModelable {
    var title: String {
        do {
            return try run?.get(runNumber).text() ?? ""
        } catch {
            return ""
        }
    }
}

extension HorseshoeRunInfoViewModel: DescriptionViewModelable {
    var description: String {
        do {
            let status = try run?.get(runNumber+1).text() ?? ""
            if status.lowercased() == "open" {
                return "Open"
            }
            return "Closed"
        } catch {
            return "Unknown"
        }
    }
}

extension HorseshoeRunInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        var difficultyImage: UIImage
        
        switch trailDifficulty {
        case .easy:
            difficultyImage = #imageLiteral(resourceName: "Green Circle")
        case .intermediate:
            difficultyImage = #imageLiteral(resourceName: "Blue Square")
        case .advanced:
            difficultyImage = #imageLiteral(resourceName: "Black Diamond")
        case .expert:
            difficultyImage = #imageLiteral(resourceName: "Double Black Diamond")
        case .terrainPark:
            difficultyImage = #imageLiteral(resourceName: "Terrain Park")
        default:
            difficultyImage = UIImage()
        }
        do {
            let status = try run?.get(runNumber+1).text() ?? ""
            if status.lowercased() == "open" {
                return [difficultyImage, #imageLiteral(resourceName: "Checkmark")]
            } else {
                return [difficultyImage, #imageLiteral(resourceName: "X")]
            }
        } catch {
            return []
        }
    }
}
