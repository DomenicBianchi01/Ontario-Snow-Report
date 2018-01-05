//
//  HorseshoeTrailViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-11-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class HorseshoeTrailViewModel {
    // MARK: - Properties
    private var lifts: [Element] = []
    private var trails: [Element] = []

    private let liftLongCoordinates: [String : [Double]] = ["Double Chair" : [-79.674447, -79.677513], //douple
                                                            "High Speed 6 Person Chair" : [-79.673947, -79.676602], //six pack
                                                            "High Rider Quad" : [-79.671780, -79.675298], //the quad
                                                            "Triple Char" : [-79.671188, -79.671138],
                                                            "Triple Chair" : [-79.671188, -79.671138],
                                                            "Kimbles Carpet" : [-79.675041, -79.677947]] //carpert
    
    private let liftLatCoordinates: [String : [Double]] = ["Double Chair" : [44.549551, 44.549053],
                                                           "High Speed 6 Person Chair" : [44.548963, 44.545916],
                                                           "High Rider Quad" : [44.546857, 44.543845],
                                                           "Triple Char" : [44.547000, 44.543035],
                                                           "Triple Chair" : [44.547000, 44.543035],
                                                           "Kimbles Carpet" : [44.550037, 44.549320]]
    
    private let trailLongCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Ponyback" : (coordinates: [-79.677947, -79.677975, -79.677828, -79.675260, -79.675041], difficulty: .easy),
                                                                                                         "Pinto" : (coordinates: [-79.677513, -79.677592, -79.677626, -79.677547, -79.674628, -79.674447], difficulty: .easy),
                                                                                                         "Roundup" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677729, -79.677741, -79.677405, -79.677580, -79.677531, -79.677253, -79.676914, -79.676287, -79.675712, -79.674733, -79.674306, -79.673936, -79.673947], difficulty: .easy),
                                                                                                         "Pony Tail" : (coordinates: [-79.676602, -79.675913, -79.675562, -79.674909, -79.674644, -79.674202, -79.674004, -79.673760, -79.673947], difficulty: .easy),
                                                                                                         "Donkey Serenade" : (coordinates: [-79.676602, -79.676580, -79.676307, -79.675999, -79.674721, -79.673999, -79.673465, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .easy),
                                                                                                         "Pony Express" : (coordinates: [-79.675298, -79.675469, -79.675582, -79.675236, -79.674721, -79.673999, -79.673465, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .easy),
                                                                                                         "Canter" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.669581], difficulty: .easy),
                                                                                                         "Mule Train" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.670041, -79.670244, -79.670430, -79.670628, -79.671104, -79.671505, -79.671907, -79.672199, -79.672146, -79.671937, -79.671488, -79.671335, -79.671185, -79.671188], difficulty: .easy),
                                                                                                         "Stampede" : (coordinates: [-79.675298, -79.675469, -79.675263, -79.675035, -79.674650, -79.673626, -79.673357, -79.672917, -79.672757, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .intermediate),
                                                                                                         "The Wave" : (coordinates: [-79.675298, -79.675469, -79.675263, -79.675279, -79.675242, -79.675064, -79.674662, -79.674094, -79.673352, -79.673217, -79.673357, -79.672917, -79.672757, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .intermediate),
                                                                                                         "Nightmare Ride" : (coordinates: [-79.675298, -79.675469, -79.675263, -79.675127, -79.674979, -79.674376, -79.674117, -79.674014, -79.673717, -79.673361, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .intermediate),
                                                                                                         "Duster" : (coordinates: [-79.675298, -79.675469, -79.675582, -79.675029, -79.674608, -79.674090, -79.673754, -79.673465, -79.673465, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .intermediate),
                                                                                                         "Bronco" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.669581, -79.669259, -79.669263, -79.669323, -79.669629, -79.670163, -79.670497, -79.671185, -79.671188], difficulty: .intermediate),
                                                                                                         "Shaggy Mane" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.669581, -79.669881, -79.670148, -79.670478, -79.670876, -79.670998, -79.671185, -79.671188], difficulty: .intermediate),
                                                                                                         "Rodeo" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677729, -79.677741, -79.677405, -79.677172, -79.677000, -79.676923, -79.676914, -79.676287, -79.675712, -79.674733, -79.674306, -79.673936, -79.673947], difficulty: .advanced),
                                                                                                         "Horsefly Hop" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677018, -79.676992, -79.676682, -79.676510, -79.676432, -79.676485, -79.676315, -79.675712, -79.674733, -79.674306, -79.673936, -79.673947], difficulty: .advanced),
                                                                                                         "Steeplechase" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677018, -79.676600, -79.676137, -79.675731, -79.674783, -79.674306, -79.673936, -79.673947], difficulty: .advanced),
                                                                                                         "Flying Mare" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677018, -79.676600, -79.675429, -79.675283, -79.674678, -79.674276, -79.673947], difficulty: .advanced),
                                                                                                         "Race Hill" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677018, -79.676600, -79.675429, -79.675047, -79.674443, -79.673947], difficulty: .advanced),
                                                                                                         "Saddleback" : (coordinates: [-79.676602, -79.676580, -79.676195, -79.675611, -79.674917, -79.674406, -79.674080, -79.672427, -79.671937, -79.671714, -79.671780], difficulty: .advanced),
                                                                                                         "Stallion Slide" : (coordinates: [-79.675298, -79.675469, -79.675582, -79.674478, -79.674207, -79.673754, -79.673465, -79.673465, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .advanced),
                                                                                                         "Horsefeathers" : (coordinates: [-79.671188, -79.671146, -79.671409, -79.671625, -79.671733, -79.672123, -79.672509, -79.672757, -79.672894, -79.672334, -79.671937, -79.671714, -79.671780], difficulty: .advanced),
                                                                                                         "Bushwacker" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.669581, -79.669259, -79.669501, -79.669746, -79.670033, -79.670218, -79.670306, -79.670464, -79.670497, -79.671185, -79.671188], difficulty: .advanced),
                                                                                                         "The Zipper" : (coordinates: [-79.671188, -79.671146, -79.670980, -79.670577, -79.670295, -79.670065, -79.669860, -79.669700, -79.669581, -79.669881, -79.670148, -79.670119, -79.670183, -79.670231, -79.670218, -79.670306, -79.670464, -79.670497, -79.671185, -79.671188], difficulty: .advanced),
                                                                                                         "The Bull Pen" : (coordinates: [-79.676602, -79.676793, -79.677116, -79.677260, -79.677018, -79.676992, -79.676682, -79.676510, -79.676432, -79.676149, -79.676110, -79.675256, -79.674733, -79.674306, -79.673936, -79.673947], difficulty: .expert)]
    
    private let trailLatCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Ponyback" : (coordinates: [44.549320, 44.549377, 44.549459, 44.550071, 44.550037], difficulty: .easy),
                                                                                                        "Pinto" : (coordinates: [44.549053, 44.549075, 44.549136, 44.549213, 44.549811, 44.549551], difficulty: .easy),
                                                                                                        "Roundup" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546220, 44.546440, 44.546821, 44.547279, 44.547822, 44.548368, 44.548652, 44.549030, 44.549098, 44.549064, 44.549149, 44.549074, 44.548963], difficulty: .easy),
                                                                                                        "Pony Tail" : (coordinates: [44.545916, 44.546195, 44.546249, 44.546336, 44.546466, 44.547176, 44.548092, 44.548706, 44.548963], difficulty: .easy),
                                                                                                        "Donkey Serenade" : (coordinates: [44.545916, 44.545716, 44.545434, 44.545357, 44.545425, 44.545470, 44.545521, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .easy),
                                                                                                        "Pony Express" : (coordinates: [44.543845, 44.543763, 44.544003, 44.544779, 44.545425, 44.545470, 44.545521, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .easy),
                                                                                                        "Canter" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544413], difficulty: .easy),
                                                                                                        "Mule Train" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544204, 44.544515, 44.544683, 44.544791, 44.544894, 44.545058, 44.545380, 44.545760, 44.546146, 44.546530, 44.546976, 44.547143, 44.547129, 44.547000], difficulty: .easy),
                                                                                                        "Stampede" : (coordinates: [44.543845, 44.543763, 44.543635, 44.543564, 44.543605, 44.543875, 44.544102, 44.544687, 44.545083, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .intermediate),
                                                                                                        "The Wave" : (coordinates: [44.543845, 44.543763, 44.543635, 44.543475, 44.543309, 44.543225, 44.543198, 44.543305, 44.543705, 44.544005, 44.544102, 44.544687, 44.545083, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .intermediate),
                                                                                                        "Nightmare Ride" : (coordinates: [44.543845, 44.543763, 44.543635, 44.543823, 44.543978, 44.544062, 44.544136, 44.544220, 44.544746, 44.545056, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .intermediate),
                                                                                                        "Duster" : (coordinates: [44.543845, 44.543763, 44.544003, 44.544147, 44.544484, 44.544950, 44.545285, 44.545470, 44.545521, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .intermediate),
                                                                                                        "Bronco" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544413, 44.544545, 44.544984, 44.545766, 44.546605, 44.546877, 44.547009, 44.547129, 44.547000], difficulty: .intermediate),
                                                                                                        "Shaggy Mane" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544413, 44.544708, 44.545022, 44.545231, 44.546427, 44.547020, 44.547129, 44.547000], difficulty: .intermediate),
                                                                                                        "Rodeo" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546220, 44.546440, 44.546821, 44.547179, 44.547846, 44.548329, 44.548652, 44.549030, 44.549098, 44.549064, 44.549149, 44.549074, 44.548963], difficulty: .advanced),
                                                                                                        "Horsefly Hop" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546263, 44.546758, 44.547084, 44.547265, 44.547479, 44.548142, 44.548465, 44.549098, 44.549064, 44.549149, 44.549074, 44.548963], difficulty: .advanced),
                                                                                                        "Steeplechase" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546263, 44.546654, 44.547305, 44.547607, 44.548664, 44.549149, 44.549074, 44.548963], difficulty: .advanced),
                                                                                                        "Flying Mare" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546263, 44.546654, 44.546960, 44.547207, 44.547917, 44.548363, 44.548963], difficulty: .advanced),
                                                                                                        "Race Hill" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546263, 44.546654, 44.546960, 44.547045, 44.547950, 44.548963], difficulty: .advanced),
                                                                                                        "Saddleback" : (coordinates: [44.545916, 44.545716, 44.545732, 44.545833, 44.545931, 44.546041, 44.546182, 44.547183, 44.547020, 44.546965, 44.546857], difficulty: .advanced),
                                                                                                        "Stallion Slide" : (coordinates: [44.543845, 44.543763, 44.544003, 44.545045, 44.545185, 44.545285, 44.545470, 44.545521, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .advanced),
                                                                                                        "Horsefeathers" : (coordinates: [44.543035, 44.542964, 44.543037, 44.543451, 44.543840, 44.544289, 44.544819, 44.545083, 44.545714, 44.546510, 44.547020, 44.546965, 44.546857], difficulty: .advanced),
                                                                                                        "Bushwacker" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544413, 44.544545, 44.544671, 44.545283, 44.545934, 44.546295, 44.546770, 44.546923, 44.547009, 44.547129, 44.547000], difficulty: .advanced),
                                                                                                        "The Zipper" : (coordinates: [44.543035, 44.542964, 44.542948, 44.542928, 44.543020, 44.543271, 44.543764, 44.544080, 44.544413, 44.544708, 44.545022, 44.545281, 44.545686, 44.545939, 44.546295, 44.546770, 44.546923, 44.547009, 44.547129, 44.547000], difficulty: .advanced),
                                                                                                        "The Bull Pen" : (coordinates: [44.545916, 44.545888, 44.545970, 44.546052, 44.546263, 44.546758, 44.547084, 44.547265, 44.547479, 44.547946, 44.548175, 44.548878, 44.549064, 44.549149, 44.549074, 44.548963], difficulty: .expert)]
    
    // MARK: - Lifecycle Functions
    init() {
        do {
            self.lifts = try mountainDetails?.get(4).getElementsByTag("td").array() ?? []
            for index in (0...3).reversed() {
                if let sectionTrails = try mountainDetails?.get(index).getElementsByTag("td").array() {
                    for trail in sectionTrails {
                        trails.append(trail)
                    }
                }
            }
        } catch {}
    }
}

extension HorseshoeTrailViewModel: CoordinatesViewModelable {
    var defaultViewCoordinates: (lat: Double, long: Double) {
        return (44.545576, -79.672968)
    }
    
    var trailCoordinates: [TrailSegment] {
        var trailSegments = [TrailSegment]()
        
        for index in 0 ... lifts.count-3 {
            guard index % 3 == 0 else {
                continue
            }
            do {
                let liftName = try lifts[index].text()
                guard let longCoordinates = liftLongCoordinates[liftName], let latCoordinates = liftLatCoordinates[liftName], let trailStatus = TrailSegment.Status(rawValue: try lifts[index+1].text().lowercased()) else {
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
                let trailName = try trails[index].text()
                guard let longCoordinates = trailLongCoordinates[trailName], let latCoordinates = trailLatCoordinates[trailName], let trailStatus = TrailSegment.Status(rawValue: try trails[index+1].text().lowercased()) else {
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
        return [LodgeInfo(title: "Base Lodge", lat: 44.549286, long: -79.673115)]
    }
}
