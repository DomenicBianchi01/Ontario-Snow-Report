//
//  CoordinatesViewModelable.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-27.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

protocol CoordinatesViewModelable {
    var trailCoordinates: [TrailSegment] { get }
    var lodgeCoordinates: [LodgeInfo] { get }
    var defaultViewCoordinates: (lat: Double, long: Double) { get }
}
