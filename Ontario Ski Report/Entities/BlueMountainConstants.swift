//
//  BlueMountainConstants.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

enum BlueTrailDifficulty: String, Codable {
    case smallPark = "SmallPark"
    case mediumPark = "MediumPark"
    case largePark = "LargePark"
    case easy = "Easy"
    case intermediate = "Intermediate"
    case advanced = "Expert"
    case advanced2 = "Difficult"
    case expert = "Extreme Terrain"
}

struct BlueSnowReport: Codable {
    let baseConditions: String
    let baseArea: [String : String]
    
    enum CodingKeys: String, CodingKey {
        case baseConditions = "BaseConditions"
        case baseArea = "BaseArea"
    }
}

struct BlueTrail: Codable {
    let name: String
    let status: String
    let difficulty: BlueTrailDifficulty
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case status = "Status"
        case difficulty = "Difficulty"
    }
}

struct BlueLift: Codable {
    let name: String
    let status: String
    let hours: [String : [String : String]]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case status = "Status"
        case hours = "Hours"
    }
}

struct BlueAreas: Codable {
    let name: String
    let trails: [BlueTrail]
    let lifts: [BlueLift]
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case trails = "Trails"
        case lifts = "Lifts"
    }
}

struct BlueWeather: Codable {
    let base: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case base = "Base"
    }
}

struct BlueData: Codable {
    let lastUpdate: String
    let snowReport: BlueSnowReport
    let mountainAreas: [BlueAreas]
    let currentConditions: [String : [String : JSONAny]]
    
    enum CodingKeys: String, CodingKey {
        case lastUpdate = "LastUpdate"
        case snowReport = "SnowReport"
        case mountainAreas = "MountainAreas"
        case currentConditions = "CurrentConditions"
    }
}
