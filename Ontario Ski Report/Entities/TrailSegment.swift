//
//  TrailSegment.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2016-10-15.
//  Copyright © 2016 Domenic Bianchi. All rights reserved.
//

import Foundation

final class TrailSegment {
    // MARK: - Enums
    enum Status: String {
        case open
        case closed
    }
    
    // MARK: - Properties
    let name: String
    let status: Status
    let latStart: Double
    let latEnd: Double
    let longStart: Double
    let longEnd: Double
    let difficulty: TrailDifficulty //If the difficulty is unknown, the segment is treated as a lift
    
    // MARK: - Lifecycle Functions
    init(name: String,
         status: Status,
         latStart: Double,
         latEnd: Double,
         longStart: Double,
         longEnd: Double,
         difficulty: TrailDifficulty) {
        self.name = name
        self.status = status
        self.latStart = latStart
        self.latEnd = latEnd
        self.longStart = longStart
        self.longEnd = longEnd
        self.difficulty = difficulty
    }
}
