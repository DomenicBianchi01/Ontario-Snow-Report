//
//  MountainRowController.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import WatchKit

final class MountainRowController: NSObject {
    // MARK: - IBOutlets
    @IBOutlet var mountainName: WKInterfaceLabel!
    
    // MARK: - Properties
    var mountain: Mountain = .blueMountain {
        didSet {
            switch mountain {
            case .blueMountain:
                mountainName.setText("Blue Mountain")
            case .saintLouis:
                mountainName.setText("Mt. St. Louis")
            case .horseshoe:
                mountainName.setText("Horseshoe Valley")
            case .glenEden:
                mountainName.setText("Glen Eden")
            }
        }
    }
}
