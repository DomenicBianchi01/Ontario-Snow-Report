//
//  MountStLouisTrailViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-11-22.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class MountStLouisTrailViewModel {
    // MARK: - Properties
    private var lifts: [Element]?
    private var liftStatus: [Element]?
    private var trails: [Element]?
    private var trailStatus: [Element]?
    
    private let liftLongCoordinates: [String : [Double]] = ["Sundance" : [-79.668066, -79.674778],
                                                            "Gentle Ben" : [-79.668493, -79.672580],
                                                            "Magic Carpet" : [-79.667426, -79.667735],
                                                            "Kinder Carpet" : [-79.668513, -79.669636],
                                                            "Summit Express" : [-79.667521, -79.674828],
                                                            "Louis Express" : [-79.666322, -79.674199],
                                                            "Adventure Express" : [-79.665023, -79.671616],
                                                            "Promenade Express" : [-79.663272, -79.671198],
                                                            "Venture" : [-79.664908, -79.671093],
                                                            "Novice Carpet" : [-79.663330, -79.664339],
                                                            "Easy Street" : [-79.662299, -79.663792],
                                                            "Outback" : [-79.663468, -79.668047]]
    
    private let liftLatCoordinates: [String : [Double]] = ["Sundance" : [44.622531, 44.622154],
                                                           "Gentle Ben" : [44.621959, 44.621300],
                                                           "Magic Carpet" : [44.622197, 44.621709],
                                                           "Kinder Carpet" : [44.621229, 44.621103],
                                                           "Summit Express" : [44.623406, 44.625363],
                                                           "Louis Express" : [44.624043, 44.625990],
                                                           "Adventure Express" : [44.627871, 44.629185],
                                                           "Promenade Express" : [44.628840, 44.630636],
                                                           "Venture" : [44.628452, 44.629819],
                                                           "Novice Carpet" : [44.628143, 44.627857],
                                                           "Easy Street" : [44.629219, 44.630175],
                                                           "Outback" : [44.630791, 44.632108]]
    
    private let trailLongCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Sundance" : (coordinates: [-79.674778, -79.675042, -79.674448, -79.673618, -79.672212, -79.668011, -79.668066], difficulty: .easy),
                                                                                                         "Gentle Ben" : (coordinates: [-79.674778, -79.675042, -79.675104, -79.674820, -79.674008, -79.673611, -79.672305, -79.668426, -79.668493], difficulty: .easy),
                                                                                                         "Saint" : (coordinates: [-79.674778, -79.675042, -79.674448, -79.673703, -79.672419, -79.671551, -79.670583, -79.669462, -79.668073, -79.668066], difficulty: .easy),
                                                                                                         "Easy Street" : (coordinates: [-79.663792, -79.663524, -79.663169, -79.662082, -79.662299], difficulty: .easy),
                                                                                                         "Follow Me" : (coordinates: [-79.669636, -79.669637, -79.668479, -79.668513], difficulty: .easy),
                                                                                                         "Kinder Slope" : (coordinates: [-79.669636, -79.669657, -79.668518, -79.668513], difficulty: .easy),
                                                                                                         "Magic Slope" : (coordinates: [-79.667735, -79.667949, -79.667661, -79.667426], difficulty: .easy),
                                                                                                         "Novice Slope" : (coordinates: [-79.664339, -79.664296, -79.663276, -79.663330], difficulty: .easy),
                                                                                                         "Big Lonely" : (coordinates: [-79.671198, -79.671329, -79.671344, -79.671390, -79.671564, -79.671844, -79.672145, -79.672289, -79.672058, -79.671733, -79.671185, -79.670035, -79.669025, -79.667976, -79.667010, -79.666517, -79.666132, -79.665611, -79.665389, -79.665232, -79.665198, -79.664948, -79.664734, -79.664372, -79.664305, -79.663842, -79.663506, -79.663328, -79.663330, -79.663524, -79.663169, -79.662082, -79.662299], difficulty: .easy),
                                                                                                         "Crescent" : (coordinates: [-79.671198, -79.671329, -79.671344, -79.671390, -79.671564, -79.671844, -79.672145, -79.672289, -79.672058, -79.671733, -79.671571, -79.671251, -79.670631, -79.669589, -79.668644, -79.667976, -79.667010, -79.666517, -79.666132, -79.665611, -79.665389, -79.665232, -79.665198, -79.664948, -79.664734, -79.664372, -79.664305, -79.663842, -79.663506, -79.663328, -79.663330, -79.663524], difficulty: .easy),
                                                                                                         "Tiroler" : (coordinates: [-79.674828, -79.674992, -79.675065, -79.675054, -79.674346, -79.673238, -79.671432, -79.670366, -79.668612, -79.667602, -79.667521], difficulty: .intermediate),
                                                                                                         "Timberline" : (coordinates: [-79.674828, -79.674992, -79.675065, -79.675054, -79.674346, -79.673238, -79.672236, -79.671100, -79.668489, -79.667786, -79.667602, -79.667521], difficulty: .intermediate),
                                                                                                         "Thunderball" : (coordinates: [-79.674828, -79.674992, -79.675065, -79.675054, -79.674346, -79.673238, -79.672481, -79.672294, -79.672145, -79.671744, -79.671333, -79.671100, -79.668489, -79.667786, -79.667602, -79.667521], difficulty: .intermediate),
                                                                                                         "T-Bar Alley" : (coordinates: [-79.672981, -79.672456, -79.671195, -79.668905, -79.667724, -79.667327, -79.667521], difficulty: .intermediate),
                                                                                                         "West Arm" : (coordinates: [-79.674828, -79.674992, -79.675065, -79.675054, -79.674346, -79.674147, -79.674082, -79.674153, -79.674448], difficulty: .intermediate),
                                                                                                         "Yodler" : (coordinates: [-79.674199, -79.674120, -79.671545, -79.670127, -79.668615, -79.667028, -79.666984, -79.666324, -79.666322], difficulty: .intermediate),
                                                                                                         "North Peak Run" : (coordinates: [-79.674828, -79.674890, -79.674810, -79.674379, -79.673892, -79.673409, -79.672271, -79.671667, -79.670806, -79.669946, -79.669732, -79.668544, -79.667849, -79.667138, -79.667018, -79.667028, -79.666984, -79.666324, -79.666322], difficulty: .intermediate),
                                                                                                         "Mount St. Louis Crossover" : (coordinates: [-79.671616, -79.671740, -79.671840, -79.672083, -79.672345, -79.672524, -79.672586, -79.672489, -79.672271, -79.671667, -79.670806, -79.669946, -79.669439, -79.667882, -79.666780, -79.665018, -79.665023], difficulty: .intermediate),
                                                                                                         "Promenade" : (coordinates: [-79.671198, -79.671329, -79.671344, -79.668931, -79.665818, -79.663328, -79.663272], difficulty: .intermediate),
                                                                                                         "Smart Alec" : (coordinates: [-79.671198, -79.671329, -79.671245, -79.670373, -79.668664, -79.667219, -79.665401, -79.664121, -79.663183, -79.662561, -79.663272], difficulty: .intermediate),
                                                                                                         "Drifter" : (coordinates: [-79.671198, -79.671329, -79.671245, -79.670373, -79.668664, -79.667831, -79.666703, -79.665401, -79.664121, -79.663183, -79.662561, -79.663272], difficulty: .intermediate),
                                                                                                         "West Peak Run" : (coordinates: [-79.674828, -79.674992, -79.673943, -79.672373, -79.670366, -79.668612, -79.667602, -79.667521], difficulty: .advanced),
                                                                                                         "East Peak Run" : (coordinates: [-79.674828, -79.674890, -79.672981, -79.670777, -79.670128, -79.667197, -79.667521], difficulty: .advanced),
                                                                                                         "Louis Express" : (coordinates: [-79.671616, -79.671740, -79.671840, -79.671845, -79.671765, -79.671575, -79.671456, -79.671238, -79.671237, -79.671136, -79.670839, -79.670437, -79.669439, -79.667882, -79.666780, -79.665018, -79.665023], difficulty: .advanced),
                                                                                                         "Adventure Run" : (coordinates: [-79.671616, -79.671740, -79.671840, -79.671845, -79.671765, -79.671575, -79.671108, -79.669061, -79.668384, -79.667882, -79.666780, -79.665018, -79.665023], difficulty: .advanced),
                                                                                                         "Ridge Run" : (coordinates: [-79.671616, -79.671740, -79.671840, -79.670882, -79.669551, -79.668491, -79.667581, -79.666134, -79.665018, -79.665023], difficulty: .advanced),
                                                                                                         "Turkey Chute" : (coordinates: [-79.671616, -79.671740, -79.671840, -79.670882, -79.669613, -79.668024, -79.667210, -79.666134, -79.665018, -79.665023], difficulty: .advanced),
                                                                                                         "Turkey Chute Mogul Run" : (coordinates: [-79.671616, -79.671740, -79.671715, -79.670608, -79.669210, -79.667718, -79.666222, -79.665636, -79.665259, -79.664893, -79.665023], difficulty: .advanced),
                                                                                                         "Venture" : (coordinates: [-79.671616, -79.671740, -79.671715, -79.671766, -79.671699, -79.671461, -79.671105, -79.667701, -79.665669, -79.665259, -79.664893, -79.665023], difficulty: .advanced),
                                                                                                         "Venture Mogul" : (coordinates: [-79.671616, -79.671740, -79.671715, -79.671766, -79.671699, -79.671461, -79.671085, -79.670725, -79.667620, -79.665989, -79.665669, -79.665259, -79.664893, -79.665023], difficulty: .advanced),
                                                                                                         "Junkyard" : (coordinates: [-79.67404, -79.67396, -79.67371, -79.67182, -79.67137, -79.6709, -79.67067, -79.67042, -79.67019, -79.66979, -79.66926, -79.66895, -79.66847, -79.66801, -79.66788, -79.66791, -79.66856, -79.66933, -79.67102, -79.67156, -79.67187, -79.67208, -79.67248, -79.67291, -79.67333, -79.67379, -79.67404], difficulty: .terrainPark),
                                                                                                          "Outback" : (coordinates: [-79.66442, -79.6638, -79.66339, -79.66339, -79.66374, -79.66437, -79.66499, -79.66552, -79.66656, -79.66707, -79.66742, -79.66792, -79.66843, -79.66839, -79.66826, -79.66822, -79.66776, -79.66722, -79.66654, -79.66625, -79.66557, -79.66523, -79.66514, -79.66442], difficulty: .terrainPark),
                                                                                                           "Skool Yard" : (coordinates: [-79.67223, -79.6721, -79.66904, -79.6691, -79.67183, -79.67223], difficulty: .terrainPark)]
    
    private let trailLatCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Sundance" : (coordinates: [44.622154, 44.622055, 44.621962, 44.621664, 44.621768, 44.622310, 44.622531], difficulty: .easy),
                                                                                                        "Gentle Ben" : (coordinates: [44.622154, 44.622055, 44.621902, 44.621649, 44.621084, 44.620997, 44.621032, 44.621642, 44.621959], difficulty: .easy),
                                                                                                        "Saint" : (coordinates: [44.622154, 44.622055, 44.621962, 44.622378, 44.622339, 44.622574, 44.622817, 44.622809, 44.622730, 44.622531], difficulty: .easy),
                                                                                                        "Easy Street" : (coordinates: [44.630175, 44.630345, 44.630041, 44.629348, 44.629219], difficulty: .easy),
                                                                                                        "Follow Me" : (coordinates: [44.621103, 44.620946, 44.621058, 44.621229], difficulty: .easy),
                                                                                                        "Kinder Slope" : (coordinates: [44.621103, 44.621239, 44.621362, 44.621229], difficulty: .easy),
                                                                                                        "Magic Slope" : (coordinates: [44.621709, 44.621788, 44.622247, 44.622197], difficulty: .easy),
                                                                                                        "Novice Slope" : (coordinates: [44.627857, 44.627816, 44.628049, 44.628143], difficulty: .easy),
                                                                                                        "Big Lonely" : (coordinates: [44.630636, 44.630659, 44.630386, 44.630017, 44.629940, 44.630091, 44.630665, 44.631107, 44.631473, 44.631675, 44.631742, 44.632196, 44.632632, 44.632999, 44.633497, 44.633695, 44.633723, 44.633424, 44.633255, 44.633156, 44.632838, 44.632376, 44.632120, 44.631872, 44.631717, 44.631262, 44.631038, 44.630899, 44.630598, 44.630345, 44.630041, 44.629348, 44.629219], difficulty: .easy),
                                                                                                        "Crescent" : (coordinates: [44.630636, 44.630659, 44.630386, 44.630017, 44.629940, 44.630091, 44.630665, 44.631107, 44.631473, 44.631675, 44.631898, 44.632150, 44.632349, 44.632728, 44.633035, 44.632999, 44.633497, 44.633695, 44.633723, 44.633424, 44.633255, 44.633156, 44.632838, 44.632376, 44.632120, 44.631872, 44.631717, 44.631262, 44.631038, 44.630899, 44.630598, 44.630345], difficulty: .easy),
                                                                                                         "Tiroler" : (coordinates: [44.625363, 44.625193, 44.625041, 44.624624, 44.624001, 44.623660, 44.623730, 44.623828, 44.623431, 44.623182, 44.623406], difficulty: .intermediate),
                                                                                                         "Timberline" : (coordinates: [44.625363, 44.625193, 44.625041, 44.624624, 44.624001, 44.623660, 44.623303, 44.623188, 44.622823, 44.622996, 44.623182, 44.623406], difficulty: .intermediate),
                                                                                                         "Thunderball" : (coordinates: [44.625363, 44.625193, 44.625041, 44.624624, 44.624001, 44.623660, 44.623093, 44.622932, 44.622875, 44.622920, 44.623042, 44.623188, 44.622823, 44.622996, 44.623182, 44.623406], difficulty: .intermediate),
                                                                                                         "T-Bar Alley" : (coordinates: [44.625098, 44.624812, 44.624480, 44.623906, 44.623789, 44.623742, 44.623406], difficulty: .intermediate),
                                                                                                         "West Arm" : (coordinates: [44.625363, 44.625193, 44.625041, 44.624624, 44.624001, 44.623478, 44.622953, 44.622392, 44.621962], difficulty: .intermediate),
                                                                                                         "Yodler" : (coordinates: [44.625990, 44.626120, 44.625469, 44.625126, 44.624837, 44.624330, 44.624089, 44.623951, 44.624043], difficulty: .intermediate),
                                                                                                         "North Peak Run" : (coordinates: [44.625363, 44.625528, 44.626154, 44.626600, 44.626848, 44.626862, 44.626547, 44.626350, 44.626394, 44.626587, 44.626587, 44.626046, 44.625609, 44.624934, 44.624476, 44.624330, 44.624089, 44.623951, 44.624043], difficulty: .intermediate),
                                                                                                         "Mount St. Louis Crossover" : (coordinates: [44.629185, 44.629220, 44.629035, 44.628833, 44.628544, 44.628005, 44.627166, 44.626808, 44.626547, 44.626350, 44.626394, 44.626587, 44.626844, 44.627199, 44.627358, 44.627666, 44.627871], difficulty: .intermediate),
                                                                                                         "Promenade" : (coordinates: [44.630636, 44.630659, 44.630386, 44.629928, 44.629190, 44.628586, 44.628840], difficulty: .intermediate),
                                                                                                         "Smart Alec" : (coordinates: [44.630636, 44.630659, 44.630909, 44.630920, 44.630873, 44.630561, 44.630226, 44.629870, 44.629587, 44.629095, 44.628840], difficulty: .intermediate),
                                                                                                         "Drifter" : (coordinates: [44.630636, 44.630659, 44.630909, 44.630920, 44.630873, 44.631026, 44.630725, 44.630226, 44.629870, 44.629587, 44.629095, 44.628840], difficulty: .intermediate),
                                                                                                         "West Peak Run" : (coordinates: [44.625363, 44.625193, 44.624830, 44.624381, 44.623828, 44.623431, 44.623182, 44.623406], difficulty: .advanced),
                                                                                                         "East Peak Run" : (coordinates: [44.625363, 44.625528, 44.625098, 44.624780, 44.624667, 44.623885, 44.623406], difficulty: .advanced),
                                                                                                         "Louis Express" : (coordinates: [44.629185, 44.629220, 44.629035, 44.628806, 44.628502, 44.628351, 44.628015, 44.627440, 44.627134, 44.626931, 44.626722, 44.626654, 44.626844, 44.627199, 44.627358, 44.627666, 44.627871], difficulty: .advanced),
                                                                                                         "Adventure Run" : (coordinates: [44.629185, 44.629220, 44.629035, 44.628806, 44.628502, 44.628351, 44.628243, 44.627479, 44.627305, 44.627199, 44.627358, 44.627666, 44.627871], difficulty: .advanced),
                                                                                                         "Ridge Run" : (coordinates: [44.629185, 44.629220, 44.629035, 44.628712, 44.628188, 44.627845, 44.627723, 44.627762, 44.627666, 44.627871], difficulty: .advanced),
                                                                                                         "Turkey Chute" : (coordinates: [44.629185, 44.629220, 44.629035, 44.628712, 44.628618, 44.628253, 44.627956, 44.627762, 44.627666, 44.627871], difficulty: .advanced),
                                                                                                         "Turkey Chute Mogul Run" : (coordinates: [44.629185, 44.629220, 44.629300, 44.629103, 44.628790, 44.628490, 44.628183, 44.628076, 44.628166, 44.628065, 44.627871], difficulty: .advanced),
                                                                                                         "Venture" : (coordinates: [44.629185, 44.629220, 44.629300, 44.629541, 44.629715, 44.629785, 44.629661, 44.628889, 44.628405, 44.628166, 44.628065, 44.627871], difficulty: .advanced),
                                                                                                         "Venture Mogul" : (coordinates: [44.629185, 44.629220, 44.629300, 44.629541, 44.629715, 44.629785, 44.629914, 44.629819, 44.629147, 44.628742, 44.628405, 44.628166, 44.628065, 44.627871], difficulty: .advanced),
                                                                                                         "Junkyard" : (coordinates: [44.62624, 44.62616, 44.62617, 44.62567, 44.62564, 44.62563, 44.62565, 44.62567, 44.62567, 44.62558, 44.62542, 44.62535, 44.62519, 44.62499, 44.62523, 44.62542, 44.62584, 44.62628, 44.62612, 44.62606, 44.62609, 44.62613, 44.62623, 44.62632, 44.62638, 44.62636, 44.62624], difficulty: .terrainPark),
                                                                                                         "Outback" : (coordinates: [44.63179, 44.6311, 44.63083, 44.63072, 44.63055, 44.63054, 44.63052, 44.63074, 44.63107, 44.63121, 44.63128, 44.63132, 44.63139, 44.63192, 44.63231, 44.63246, 44.63255, 44.63257, 44.63259, 44.63243, 44.63224, 44.63217, 44.63224, 44.63179], difficulty: .terrainPark),
                                                                                                          "Skool Yard" : (coordinates: [44.62124, 44.62115, 44.6216, 44.62182, 44.62138, 44.62124], difficulty: .terrainPark)]
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            if let liftCopy = mountainDetails?.get(2).copy() as? Element {
                let liftGroup = try liftCopy.append(mountainDetails?.get(3).html() ?? "")
                lifts = try liftGroup.select(".title").array()
                liftStatus = try liftGroup.select(".status").array()
            }
            if let trailCopy = mountainDetails?.get(0).copy() as? Element {
                let trailGroup = try trailCopy.append(mountainDetails?.get(1).html() ?? "")
                try trailGroup.append(mountainDetails?.get(4).html() ?? "")
                try trailGroup.append(mountainDetails?.get(5).html() ?? "")
                try trailGroup.append(mountainDetails?.get(6).html() ?? "")
                trails = try trailGroup.select(".title").array()
                trailStatus = try trailGroup.select(".status").array()
            }
        } catch {}
    }
}

extension MountStLouisTrailViewModel: CoordinatesViewModelable {
    var defaultViewCoordinates: (lat: Double, long: Double) {
        return (44.626048, -79.6662390)
    }
    
    var trailCoordinates: [TrailSegment] {
        var trailSegments = [TrailSegment]()
        
        guard let trails = trails,
            let trailStatus = trailStatus,
            let lifts = lifts,
            let liftStatus = liftStatus else {
            return []
        }
        
        for (name, status) in zip(trails, trailStatus) {
            do {
                let trailName = try name.text()
                guard let longCoordinates = trailLongCoordinates[trailName], let latCoordinates = trailLatCoordinates[trailName], let trailStatus = TrailSegment.Status(rawValue: try status.text().lowercased()) else {
                    continue
                }
                
                for index in 0 ..< longCoordinates.coordinates.count-1 {
                    let segment = TrailSegment(name: trailName, status: trailStatus, latStart: latCoordinates.coordinates[index], latEnd: latCoordinates.coordinates[index+1], longStart: longCoordinates.coordinates[index], longEnd: longCoordinates.coordinates[index+1], difficulty: longCoordinates.difficulty)
                    trailSegments.append(segment)
                }
            } catch {}
        }
        
        for (name, status) in zip(lifts, liftStatus) {
            do {
                let liftName = try name.text()
                guard let longCoordinates = liftLongCoordinates[liftName], let latCoordinates = liftLatCoordinates[liftName], let trailStatus = TrailSegment.Status(rawValue: try status.text().lowercased()) else {
                    continue
                }
                
                for index in 0 ..< longCoordinates.count-1 {
                    let segment = TrailSegment(name: liftName, status: trailStatus, latStart: latCoordinates[index], latEnd: latCoordinates[index+1], longStart: longCoordinates[index], longEnd: longCoordinates[index+1], difficulty: .unknown)
                    trailSegments.append(segment)
                }
            } catch {}
        }
        
        return trailSegments
    }
    
    var lodgeCoordinates: [LodgeInfo] {
        return [LodgeInfo(title: "St. Louis Base Lodge", lat: 44.623142, long: -79.666871),
                LodgeInfo(title: "Moonstone Base Lodge", lat: 44.628445, long: -79.662806)]
    }
}
