//
//  GlenEdenTrailViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class GlenEdenTrailViewModel {
    // MARK: - Properties
    private var lifts: [Element] = []
    private var trails: [Element] = []

    //There is a grammar error on Glen Eden's website where "Updraft Chairlift" is missing the space
    private let liftLongCoordinates: [String : [Double]] = ["Limestone Chairlift" : [-79.942984, -79.940222],
                                                            "Ridge Chairlift" : [-79.943989, -79.941703],
                                                            "UpdraftChairlift" : [-79.946280, -79.941707],
                                                            "Updraft Chairlift" : [-79.946280, -79.941707],
                                                            "Caterpillar Carpet" : [-79.946961, -79.945677],
                                                            "Lasso Rope Tow" : [-79.946900, -79.944781],
                                                            "Little Dipper Carpet" : [-79.944266, -79.945373],
                                                            "Shuttle Carpet" : [-79.944097, -79.944975]]
    
    private let liftLatCoordinates: [String : [Double]] = ["Limestone Chairlift" : [43.506455, 43.504891],
                                                           "Ridge Chairlift" : [43.505615, 43.502976],
                                                           "UpdraftChairlift" : [43.502851, 43.502636],
                                                           "Updraft Chairlift" : [43.502851, 43.502636],
                                                           "Caterpillar Carpet" : [43.502195, 43.501740],
                                                           "Lasso Rope Tow" : [43.501102, 43.500622],
                                                           "Little Dipper Carpet" : [43.506916, 43.507253],
                                                           "Shuttle Carpet" : [43.507259, 43.507593]]
    
    private let trailLongCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Quarry Run" : (coordinates: [-79.940222, -79.940058, -79.940171, -79.940242, -79.940157, -79.940243, -79.940972, -79.941468, -79.942536, -79.943168, -79.942984], difficulty: .easy),
                                                                                                         "Escarpment Run" : (coordinates: [-79.941703, -79.941556, -79.941700, -79.941803, -79.941713, -79.941197, -79.940242], difficulty: .easy),
                                                                                                         "Grasshopper" : (coordinates: [-79.945677, -79.945612, -79.946903, -79.946961], difficulty: .easy),
                                                                                                         "Comet" : (coordinates: [-79.945373, -79.945463, -79.945371, -79.945331, -79.944917, -79.944649, -79.944361, -79.944266], difficulty: .easy),
                                                                                                         "Little Dipper" : (coordinates: [-79.945373, -79.945463, -79.944361, -79.944266], difficulty: .easy),
                                                                                                         "Milky Way" : (coordinates: [-79.945373, -79.945182, -79.944141, -79.944266], difficulty: .easy),
                                                                                                         "Shooting Star" : (coordinates: [-79.944975, -79.944773, -79.943985, -79.944097], difficulty: .easy),
                                                                                                         "Scimitar" : (coordinates: [-79.940222, -79.940058, -79.940171, -79.940658, -79.941060, -79.941899, -79.942536, -79.943168, -79.942984], difficulty: .intermediate),
                                                                                                         "Sidewinder" : (coordinates: [-79.941703, -79.941556, -79.941700, -79.941803, -79.942413, -79.943018, -79.943521, -79.944022, -79.944134, -79.944050, -79.943989], difficulty: .intermediate),
                                                                                                         "Butternut" : (coordinates: [-79.940222, -79.940058, -79.940171, -79.940895, -79.941399, -79.942084, -79.942536, -79.943168, -79.942984], difficulty: .intermediate),
                                                                                                          "Twister" : (coordinates: [-79.941707, -79.941545, -79.941623, -79.941887, -79.942502, -79.943504, -79.944748, -79.946055, -79.946469, -79.946489, -79.946280], difficulty: .intermediate),
                                                                                                          "Wild West" : (coordinates: [-79.944781, -79.944863, -79.946889, -79.946900], difficulty: .intermediate),
                                                                                                         "Boomerang" : (coordinates: [-79.940222, -79.940168, -79.940440, -79.941472, -79.942638, -79.943003, -79.943168, -79.942984], difficulty: .advanced),
                                                                                                         "Challenger" : (coordinates: [-79.941703, -79.941556, -79.941700, -79.941803, -79.942413, -79.943093, -79.944299, -79.945248, -79.946005, -79.946489, -79.946280], difficulty: .advanced),
                                                                                                         "Night Hawk" : (coordinates: [-79.94217, -79.94192, -79.94265, -79.9444, -79.94538, -79.94536, -79.94217], difficulty: .terrainPark),
                                                                                                         "Falcon" : (coordinates: [-79.94217, -79.94189, -79.94219, -79.94226, -79.94236, -79.9425, -79.94289, -79.94374, -79.94405, -79.94452, -79.94451, -79.94492, -79.94486, -79.94449, -79.944, -79.94271, -79.94217], difficulty: .terrainPark),
                                                                                                         "Monarch" : (coordinates: [-79.94574, -79.94703, -79.94721, -79.94595, -79.94574], difficulty: .terrainPark)]
    
    private let trailLatCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Quarry Run" : (coordinates: [43.504891, 43.504915, 43.505166, 43.505748, 43.506369, 43.506588, 43.506692, 43.506771, 43.506683, 43.506549, 43.506455], difficulty: .easy),
                                                                                                        "Escarpment Run" : (coordinates: [43.502976, 43.502941, 43.503429, 43.503718, 43.504239, 43.504741, 43.505748], difficulty: .easy),
                                                                                                        "Grasshopper" : (coordinates: [43.501740, 43.501865, 43.502300, 43.502195], difficulty: .easy),
                                                                                                        "Comet" : (coordinates: [43.507253, 43.507113, 43.506798, 43.506596, 43.506409, 43.506504, 43.506799, 43.506916], difficulty: .easy),
                                                                                                        "Little Dipper" : (coordinates: [43.507253, 43.507113, 43.506799, 43.506916], difficulty: .easy),
                                                                                                         "Milky Way" : (coordinates: [43.507253, 43.507441, 43.507092, 43.506916], difficulty: .easy),
                                                                                                         "Shooting Star" : (coordinates: [43.507593, 43.507707, 43.507406, 43.507259], difficulty: .easy),
                                                                                                        "Scimitar" : (coordinates: [43.504891, 43.504915, 43.505166, 43.505608, 43.505989, 43.506395, 43.506683, 43.506549, 43.506455], difficulty: .intermediate),
                                                                                                        "Sidewinder" : (coordinates: [43.502976, 43.502941, 43.503429, 43.503718, 43.503664, 43.503901, 43.504625, 43.505384, 43.505673, 43.505695, 43.505615], difficulty: .intermediate),
                                                                                                        "Butternut" : (coordinates: [43.504891, 43.504915, 43.505166, 43.505379, 43.505637, 43.506228, 43.506683, 43.506549, 43.506455], difficulty: .intermediate),
                                                                                                        "Twister" : (coordinates: [43.502636, 43.502558, 43.502375, 43.502199, 43.502101, 43.502103, 43.502288, 43.502605, 43.502709, 43.502869, 43.502851], difficulty: .intermediate),
                                                                                                        "Wild West" : (coordinates: [43.500622, 43.500493, 43.500957, 43.501102], difficulty: .intermediate),
                                                                                                        "Boomerang" : (coordinates: [43.504891, 43.504785, 43.504840, 43.505353, 43.505774, 43.506069, 43.506549, 43.506455], difficulty: .advanced),
                                                                                                        "Challenger" : (coordinates: [43.502976, 43.502941, 43.503429, 43.503718, 43.503664, 43.503640, 43.503606, 43.503431, 43.503170, 43.502869, 43.502851], difficulty: .advanced),
                                                                                                        "Night Hawk" : (coordinates: [43.50344, 43.50327, 43.50291, 43.50295, 43.50301, 43.50319, 43.50344], difficulty: .terrainPark),
                                                                                                        "Falcon" : (coordinates: [43.50344, 43.50328, 43.50308, 43.50301, 43.50281, 43.50256, 43.50257, 43.50256, 43.50257, 43.50259, 43.50268, 43.50277, 43.50295, 43.50288, 43.5028, 43.50276, 43.50344], difficulty: .terrainPark),
                                                                                                         "Monarch" : (coordinates: [43.50169, 43.50214, 43.50192, 43.50151, 43.50169], difficulty: .terrainPark)]
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            self.lifts = try mountainDetails?.get(3).getElementsByTag("td").filter({ !$0.hasAttr("colspan") }) ?? []
            self.trails = try mountainDetails?.get(2).getElementsByTag("td").filter({ !$0.hasAttr("colspan") }) ?? []
        } catch {}
    }
}

extension GlenEdenTrailViewModel: CoordinatesViewModelable {
    var defaultViewCoordinates: (lat: Double, long: Double) {
        return (43.506194, -79.943810)
    }
    
    var trailCoordinates: [TrailSegment] {
        var trailSegments = [TrailSegment]()
        for index in 0 ... lifts.count-3 {
            guard index % 3 == 0 else {
                continue
            }
            do {
                let liftName = try lifts[index+1].text()
                guard let longCoordinates = liftLongCoordinates[liftName], let latCoordinates = liftLatCoordinates[liftName], let trailStatus = TrailSegment.Status(rawValue: try lifts[index].text().lowercased()) else {
                    continue
                }
                
                for index in 0 ..< longCoordinates.count-1 {
                    let segment = TrailSegment(name: liftName, status: trailStatus, latStart: latCoordinates[index], latEnd: latCoordinates[index+1], longStart: longCoordinates[index], longEnd: longCoordinates[index+1], difficulty: .unknown)
                    trailSegments.append(segment)
                }
            } catch {}
        }
        
        for index in 0 ... trails.count-3 {
            guard index % 3 == 0 else {
                continue
            }
            do {
                let trailName = try trails[index+1].text()
                guard let longCoordinates = trailLongCoordinates[trailName], let latCoordinates = trailLatCoordinates[trailName], let trailStatus = TrailSegment.Status(rawValue: try trails[index].text().lowercased()) else {
                    continue
                }

                for index in 0 ..< longCoordinates.coordinates.count-1 {
                    let segment = TrailSegment(name: trailName, status: trailStatus, latStart: latCoordinates.coordinates[index], latEnd: latCoordinates.coordinates[index+1], longStart: longCoordinates.coordinates[index], longEnd: longCoordinates.coordinates[index+1], difficulty: longCoordinates.difficulty)
                    trailSegments.append(segment)
                }
            } catch {}
        }
        
        return trailSegments
    }
    
    var lodgeCoordinates: [LodgeInfo] {
        return [LodgeInfo(title: "Base Lodge", lat: 43.506179, long: -79.943493)]
    }
}
