//
//  GlenEdenRunInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class GlenEdenRunInfoViewModel {
    // MARK: - Properties
    private var run: [Element]? = nil
    private var runNumber: Int
    
    // MARK: - Lifecycle Functions
    init(for trailDifficulty: TrailDifficulty, and runNumber: Int) {
        self.runNumber = runNumber * 3
        do {
            self.run = try mountainDetails?.get(2).getElementsByTag("td").filter({ !$0.hasAttr("colspan") })
        } catch {}
    }
}

extension GlenEdenRunInfoViewModel: TitleViewModelable {
    var title: String {
        do {
            return try run?[runNumber+1].text() ?? ""
        } catch {
            return ""
        }
    }
}

extension GlenEdenRunInfoViewModel: DescriptionViewModelable {
    var description: String {
        do {
            let status = try run?[runNumber].text() ?? ""
            if status.lowercased() == "open" {
                return "Open"
            }
            return "Closed"
        } catch {
            return "Unknown"
        }
    }
}

extension GlenEdenRunInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        var difficultyImage = UIImage()
        do {
            if let trailDifficulty = try run?[runNumber+2].text() {
                if trailDifficulty.contains("easiest")  {
                    difficultyImage = #imageLiteral(resourceName: "Green Circle")
                } else if trailDifficulty.contains("more-difficult") {
                    difficultyImage = #imageLiteral(resourceName: "Blue Square")
                } else if trailDifficulty.contains("difficult") {
                    difficultyImage = #imageLiteral(resourceName: "Black Diamond")
                } else if trailDifficulty.contains("freestyle") {
                    difficultyImage = #imageLiteral(resourceName: "Terrain Park")
                }
            }
            let status = try run?[runNumber].text() ?? ""
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
