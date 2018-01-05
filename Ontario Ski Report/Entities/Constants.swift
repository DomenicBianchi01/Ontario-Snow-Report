//
//  Constants.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-18.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

// MARK: Enums
///TrailDifficulty maps to FilterMode
enum TrailDifficulty: Int {
    case unknown
    case easy
    case intermediate
    case advanced
    case expert
    case terrainPark
}

enum Mountain: Int {
    case blueMountain
    case saintLouis
    case horseshoe
    case glenEden
}
