//
//  LodgeInfo.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-27.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

class LodgeInfo {
    let title: String
    let lat: Double
    let long: Double
    
    init(title: String,
         lat: Double,
         long: Double) {
        self.title = title
        self.lat = lat
        self.long = long
    }
}
