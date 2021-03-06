//
//  BlueMountainTrailViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-27.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

final class BlueMountainTrailViewModel {
    // MARK: - Properties
    private var trails = [BlueTrail]()
    private var lifts = [BlueLift]()
    
    private let liftLongCoordinates: [String : [Double]] = ["Orchard Express" : [-80.302556, -80.314221],
                                                            "Southern Comfort" : [-80.317479, -80.308044],
                                                            "Silver Bullet" : [-80.312988, -80.321397],
                                                            "Century Express" : [-80.317462, -80.325249],
                                                            "Weider Express" : [-80.323714, -80.329907],
                                                            "Voyageur" : [-80.305084, -80.308815],
                                                            "Explorer" : [-80.305689, -80.307027],
                                                            "Little Ripper" : [-80.306728, -80.307416],
                                                            "Easy Rider" : [-80.313917, -80.315688],
                                                            "Undergrad" : [-80.315816, -80.316602],
                                                            "Graduate" : [-80.315466, -80.317992]]
    
    private let liftLatCoordinates: [String : [Double]] = ["Orchard Express" : [44.495026, 44.488299],
                                                           "Southern Comfort" : [44.491897, 44.498482],
                                                           "Silver Bullet" : [44.502297, 44.497017],
                                                           "Century Express" : [44.505881, 44.501740],
                                                           "Weider Express" : [44.509956, 44.504817],
                                                           "Voyageur" : [44.496811, 44.494261],
                                                           "Explorer" : [44.497106, 44.496799],
                                                           "Little Ripper" : [44.497355, 44.497110],
                                                           "Easy Rider" : [44.503606, 44.503367],
                                                           "Undergrad" : [44.504225, 44.503500],
                                                           "Graduate" : [44.504462, 44.502980]]
    
    //NOTE: Fall Line is no longer an open trail (its a terrain park)
    private let trailLongCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Big Baby" : (coordinates: [-80.308815, -80.308936, -80.305374, -80.305084], difficulty: .easy),
                                                                                                         "Enchanted Forest" : (coordinates: [-80.308815, -80.308654, -80.307953, -80.307848, -80.307527, -80.307410, -80.307305, -80.307063, -80.306566, -80.306488, -80.306717, -80.306309, -80.305956, -80.305764, -80.305629, -80.305621, -80.305845, -80.305374, -80.305084], difficulty: .easy),
                                                                                                         "Explorer" : (coordinates: [-80.307027, -80.307013, -80.305746, -80.305689], difficulty: .easy),
                                                                                                         "Little Ripper" : (coordinates: [-80.307416, -80.307497, -80.306755, -80.306728], difficulty: .easy),
                                                                                                         "Easy Rider" : (coordinates: [-80.315688, -80.315539, -80.313938, -80.313917], difficulty: .easy),
                                                                                                         "Undergrad" : (coordinates: [-80.316602, -80.316302, -80.315678, -80.315816], difficulty: .easy),
                                                                                                         "Graduate" : (coordinates: [-80.317992, -80.318124, -80.318073, -80.315666, -80.315466], difficulty: .easy),
                                                                                                         "Southern Cross" : (coordinates: [-80.314221, -80.314568, -80.314960, -80.315340, -80.315775, -80.316093, -80.316011, -80.315800, -80.315370, -80.314879, -80.314599, -80.314230, -80.313456, -80.313361, -80.312950, -80.312520, -80.312404, -80.312419, -80.312024, -80.311771, -80.311423, -80.309079, -80.308137, -80.307754, -80.307100, -80.306828, -80.306472, -80.305966, -80.304883, -80.302689, -80.302556], difficulty: .easy),
                                                                                                         "Gord's Groove" : (coordinates: [-80.314221, -80.314064, -80.312992, -80.311839, -80.311059, -80.310658, -80.309512, -80.308950, -80.308572, -80.307672, -80.306798, -80.306624, -80.306271, -80.303898, -80.302416, -80.302121, -80.302173, -80.302067, -80.302460, -80.302556], difficulty: .easy),
                                                                                                         "Due North" : (coordinates: [-80.321397, -80.321677, -80.321912, -80.321981, -80.322097, -80.322601, -80.323020, -80.323746, -80.324443, -80.325249], difficulty: .easy),
                                                                                                         "Happy Valley" : (coordinates: [-80.325249, -80.325420, -80.325039, -80.326506, -80.327100, -80.325130, -80.323173, -80.321795, -80.320420, -80.318034, -80.317462], difficulty: .easy),
                                                                                                         "Butternut" : (coordinates: [-80.314221, -80.314064, -80.311677, -80.309578, -80.308458, -80.307132, -80.306576, -80.304423, -80.302689, -80.302556], difficulty: .intermediate),
                                                                                                         "Fall Line" : (coordinates: [-80.314221, -80.314064, -80.311677, -80.309578, -80.308842, -80.307369, -80.305794, -80.304730, -80.304283, -80.303936, -80.302460, -80.302556], difficulty: .intermediate),
                                                                                                         "Juicer" : (coordinates: [-80.314221, -80.314064, -80.312992, -80.311839, -80.311059, -80.310658, -80.310528, -80.310330, -80.309040, -80.307820, -80.306604, -80.304853, -80.303630, -80.302972, -80.302445, -80.302460, -80.302556], difficulty: .intermediate),
                                                                                                         "Finally" : (coordinates: [-80.314221, -80.314064, -80.312992, -80.311839, -80.311059, -80.310658, -80.309791, -80.308887, -80.308627, -80.307967, -80.307633, -80.307159, -80.305723, -80.302603, -80.302173, -80.302067, -80.302460, -80.302556], difficulty: .intermediate),
                                                                                                         "Founders" : (coordinates: [-80.314221, -80.314064, -80.312992, -80.311839, -80.311059, -80.310658, -80.309791, -80.308887, -80.308627, -80.307967, -80.307633, -80.306778, -80.302603, -80.302173, -80.302067, -80.302460, -80.302556], difficulty: .intermediate),
                                                                                                         "Waterfall" : (coordinates: [-80.317479, -80.316694, -80.315775, -80.313824, -80.311965, -80.309791, -80.308622, -80.308180, -80.308271, -80.307788, -80.308044], difficulty: .intermediate),
                                                                                                         "Sunrise" : (coordinates: [-80.317479, -80.317620, -80.317342, -80.317400, -80.317773, -80.317310, -80.316557, -80.315453, -80.314407, -80.313816, -80.313007, -80.307788, -80.308044], difficulty: .intermediate),
                                                                                                         "Cruiser" : (coordinates: [-80.317620, -80.317342, -80.317400, -80.317773, -80.317310, -80.316557, -80.315453, -80.314210, -80.313816, -80.308593, -80.308044], difficulty: .intermediate),
                                                                                                         "Tranquility" : (coordinates: [-80.321397, -80.321677, -80.320052, -80.317983, -80.317288, -80.316620, -80.313162, -80.312757, -80.312988], difficulty: .intermediate),
                                                                                                         "Smart Alec" : (coordinates: [-80.321397, -80.321677, -80.321912, -80.320943, -80.320484, -80.320147, -80.318866, -80.317606, -80.313711, -80.312988], difficulty: .intermediate),
                                                                                                         "Yahoo" : (coordinates: [-80.321397, -80.321677, -80.321912, -80.320943, -80.320484, -80.320977, -80.320535, -80.319269, -80.318792, -80.317606, -80.313711, -80.312988], difficulty: .intermediate),
                                                                                                         "Village Way" : (coordinates: [-80.321397, -80.321677, -80.321912, -80.321981, -80.322097, -80.322601, -80.323020, -80.321959, -80.321296, -80.321269, -80.320563, -80.318635, -80.317481, -80.316851, -80.315006, -80.313711, -80.312988], difficulty: .intermediate),
                                                                                                         "Legacy" : (coordinates: [-80.325249, -80.324684, -80.323925, -80.323012, -80.322409, -80.321396, -80.320794, -80.318839, -80.318374, -80.316939, -80.317462], difficulty: .intermediate),
                                                                                                         "Apple Bowl" : (coordinates: [-80.325249, -80.324684, -80.323925, -80.322982, -80.321618, -80.318374, -80.316939, -80.317462], difficulty: .intermediate),
                                                                                                         "Going South" : (coordinates: [-80.329907, -80.329782, -80.328726, -80.327751, -80.327100, -80.325130, -80.323173, -80.321795, -80.320420, -80.318034, -80.317462], difficulty: .intermediate),
                                                                                                         "Dog Sled" : (coordinates: [-80.323173, -80.323112, -80.323039, -80.323071, -80.323320, -80.323998, -80.323431, -80.323714], difficulty: .intermediate),
                                                                                                         "Schuss" : (coordinates: [-80.329907, -80.330802, -80.331291, -80.331482, -80.332025, -80.330951, -80.330961, -80.330159, -80.328484, -80.327108, -80.325743, -80.325187, -80.324648, -80.323714], difficulty: .intermediate),
                                                                                                         "L-Hill" : (coordinates: [-80.321397, -80.321092, -80.320762, -80.320253, -80.319255, -80.317532, -80.316065, -80.315355, -80.314448, -80.313623, -80.313738, -80.312884, -80.312843, -80.312757, -80.312988], difficulty: .intermediate),
                                                                                                         "Susan's Hideaway" : (coordinates: [-80.321397, -80.321092, -80.320762, -80.320253, -80.319878, -80.319288, -80.319214, -80.319092, -80.318095, -80.317415, -80.316777, -80.316085, -80.315102, -80.314597, -80.314448, -80.313623, -80.313738, -80.312884, -80.312843, -80.312757, -80.312988], difficulty: .intermediate),
                                                                                                         "Dr. Doug" : (coordinates: [-80.317479, -80.317620, -80.317342, -80.317400, -80.317773, -80.317310, -80.316557, -80.316090, -80.315638, -80.315419, -80.314810, -80.314490, -80.312607, -80.311989, -80.311608, -80.311107, -80.310766, -80.310385, -80.309478, -80.308593, -80.308044], difficulty: .intermediate),
                                                                                                         "Crooked Oak" : (coordinates: [-80.317479, -80.316694, -80.315775, -80.313824, -80.313475, -80.312276, -80.310748, -80.308622, -80.308180, -80.308271, -80.307788, -80.308044], difficulty: .advanced),
                                                                                                         "Calamity Lane" : (coordinates: [-80.325249, -80.324684, -80.323925, -80.322982, -80.322198, -80.320951, -80.318374, -80.316939, -80.317462], difficulty: .advanced),
                                                                                                         "Willy's" : (coordinates: [-80.325249, -80.325016, -80.324304, -80.323639, -80.323337, -80.322582, -80.322175, -80.320420, -80.318034, -80.317462], difficulty: .advanced),
                                                                                                         "Hog's Back" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.328879, -80.328252, -80.327595, -80.326963, -80.326232, -80.324992, -80.323896, -80.323522, -80.323320, -80.323998, -80.323431, -80.323714], difficulty: .advanced),
                                                                                                         "Senator / Larway" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.329168, -80.329206, -80.329277, -80.329079, -80.328681, -80.328387, -80.325972, -80.325398, -80.325007, -80.324648, -80.323714], difficulty: .advanced),
                                                                                                         "Rabbits Run" : (coordinates: [-80.329907, -80.330802, -80.330690, -80.330492, -80.330305, -80.330149, -80.330395, -80.329322, -80.328083, -80.326604, -80.325743, -80.325187, -80.324648, -80.323714], difficulty: .advanced),
                                                                                                         "Kandahar" : (coordinates: [-80.329907, -80.330802, -80.331291, -80.331482, -80.332025, -80.332513, -80.332707, -80.332981, -80.332423, -80.331632, -80.331197, -80.330508, -80.330280, -80.329852, -80.329453, -80.329024, -80.328623, -80.328009, -80.327668, -80.327108, -80.325743, -80.325187, -80.324648, -80.323714], difficulty: .advanced),
                                                                                                         "Dieppe" : (coordinates: [-80.329907, -80.330802, -80.331291, -80.331482, -80.332025, -80.332513, -80.332707, -80.332981, -80.333286, -80.333539, -80.332886, -80.331661, -80.331268, -80.330280, -80.329852, -80.329453, -80.329024, -80.328623, -80.328009, -80.327668, -80.327108, -80.325743, -80.325187, -80.324648, -80.323714], difficulty: .advanced),
                                                                                                         "Memory Lane" : (coordinates: [-80.321397, -80.321092, -80.320815, -80.320298, -80.319989, -80.319792, -80.319594, -80.319161, -80.317419, -80.313738, -80.312884, -80.312843, -80.312757, -80.312988], difficulty: .advanced),
                                                                                                         "Rinus Run" : (coordinates: [-80.321397, -80.321092, -80.320815, -80.320298, -80.319989, -80.319792, -80.319594, -80.319161, -80.317419, -80.317037, -80.316387, -80.313623, -80.313738, -80.312884, -80.312843, -80.312757, -80.312988], difficulty: .advanced),
                                                                                                         "Burner" : (coordinates: [-80.325249, -80.325016, -80.324304, -80.323662, -80.323207, -80.323013, -80.322696, -80.322578, -80.322493, -80.322471, -80.322583, -80.322689, -80.322640, -80.322456, -80.322223, -80.322120, -80.322093, -80.321939, -80.321656, -80.320218, -80.318374, -80.316939, -80.317462], difficulty: .advanced),
                                                                                                         "Elevator Shaft" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.328879, -80.328252, -80.327791, -80.326840, -80.325122, -80.324729, -80.323998, -80.323431, -80.323714], difficulty: .expert),
                                                                                                         "Avalanche" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.328879, -80.328369, -80.327536, -80.326499, -80.325263, -80.323998, -80.323431, -80.323714], difficulty: .expert),
                                                                                                         "Spectacular" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.328879, -80.328369, -80.327178, -80.325387, -80.323998, -80.323431, -80.323714], difficulty: .expert),
                                                                                                         "Little Devil" : (coordinates: [-80.329907, -80.329782, -80.329599, -80.329511, -80.328879, -80.328369, -80.328474, -80.328481, -80.328252, -80.325454, -80.324648, -80.323714], difficulty: .expert),
                                                                                                         "Lone Rider" : (coordinates: [-80.329907, -80.330802, -80.330690, -80.329808, -80.329091, -80.328472, -80.327785, -80.327186, -80.326683, -80.325977, -80.325187, -80.324648, -80.323714], difficulty: .expert),
                                                                                                         "Starting Gate" : (coordinates: [-80.329907, -80.330802, -80.330690, -80.330492, -80.330305, -80.330149, -80.329393, -80.328672, -80.327380, -80.325743, -80.325187, -80.324648, -80.323714], difficulty: .expert),
                                                                                                          "Badlands Terrain Park" : (coordinates: [-80.309579, -80.309156, -80.307840, -80.307412, -80.307218, -80.306861, -80.306520, -80.305991, -80.305817, -80.305726, -80.304222, -80.303848, -80.304042, -80.304209, -80.304607, -80.305031, -80.305728, -80.306238, -80.306901, -80.307284, -80.307599, -80.307860, -80.308299, -80.309579], difficulty: .terrainPark)]
    
    private let trailLatCoordinates: [String : (coordinates: [Double], difficulty: TrailDifficulty)] = ["Big Baby" : (coordinates: [44.494261, 44.494773, 44.496976, 44.496811], difficulty: .easy),
                                                                                                        "Enchanted Forest" : (coordinates: [44.494261, 44.494176, 44.494705, 44.494742, 44.494615, 44.494593, 44.494727, 44.495047, 44.495433, 44.495634, 44.495774, 44.496098, 44.495952, 44.495882, 44.495938, 44.496124, 44.496515, 44.496976, 44.496811], difficulty: .easy),
                                                                                                        "Explorer" : (coordinates: [44.496799, 44.496944, 44.497182, 44.497106], difficulty: .easy),
                                                                                                        "Little Ripper" : (coordinates: [44.497110, 44.497200, 44.497394, 44.497355], difficulty: .easy),
                                                                                                        "Easy Rider" : (coordinates: [44.503367, 44.503192, 44.503451, 44.503606], difficulty: .easy),
                                                                                                        "Undergrad" : (coordinates: [44.503500, 44.503398, 44.504151, 44.504225], difficulty: .easy),
                                                                                                        "Graduate" : (coordinates: [44.502980, 44.503001, 44.503241, 44.504630, 44.504462], difficulty: .easy),
                                                                                                        "Southern Cross" : (coordinates: [44.488299, 44.488504, 44.488687, 44.488778, 44.488940, 44.489082, 44.489480, 44.489773, 44.490135, 44.490712, 44.491170, 44.491367, 44.491578, 44.491634, 44.491920, 44.492104,  44.492361, 44.492589, 44.492949, 44.493294, 44.493545, 44.494053, 44.493793, 44.493821, 44.494037, 44.494177, 44.494457, 44.494583, 44.494855,  44.495118, 44.495026], difficulty: .easy),
                                                                                                        "Gord's Groove" : (coordinates: [44.488299, 44.488208, 44.488741, 44.489004, 44.489317, 44.489484, 44.489589, 44.489680, 44.489801, 44.489813, 44.489726, 44.489534, 44.489450, 44.490244, 44.491177, 44.492141, 44.492790, 44.493712, 44.494698, 44.495026], difficulty: .easy),
                                                                                                        "Due North" : (coordinates: [44.497017, 44.497236, 44.497657, 44.497882, 44.498179, 44.498766, 44.499263, 44.500174, 44.500943, 44.501740], difficulty: .easy),
                                                                                                        "Happy Valley" : (coordinates: [44.501740, 44.501908, 44.502611, 44.503368, 44.503875, 44.503953, 44.504728, 44.505129, 44.505549, 44.506226, 44.505881], difficulty: .easy),
                                                                                                        "Butternut" : (coordinates: [44.488299, 44.488208, 44.489658, 44.491069, 44.492449, 44.493233, 44.493722, 44.494406, 44.495118, 44.495026], difficulty: .intermediate),
                                                                                                        "Fall Line" : (coordinates: [44.488299, 44.488208, 44.489658, 44.491069, 44.491190, 44.492112, 44.493024, 44.493297, 44.493766, 44.494090, 44.494698, 44.495026], difficulty: .intermediate),
                                                                                                        "Juicer" : (coordinates: [44.488299, 44.488208, 44.488741, 44.489004, 44.489317, 44.489484, 44.489903, 44.490076, 44.490563, 44.490800, 44.491594, 44.492241, 44.492995, 44.493646, 44.494142, 44.494698, 44.495026], difficulty: .intermediate),
                                                                                                        "Finally" : (coordinates: [44.488299, 44.488208, 44.488741, 44.489004, 44.489317, 44.489484, 44.489560, 44.489697, 44.489783, 44.489822, 44.489830, 44.490299, 44.491021, 44.492149, 44.492790, 44.493712, 44.494698, 44.495026], difficulty: .intermediate),
                                                                                                        "Founders" : (coordinates: [44.488299, 44.488208, 44.488741, 44.489004, 44.489317, 44.489484, 44.489560, 44.489697, 44.489783, 44.489822, 44.489830, 44.489711, 44.492149, 44.492790, 44.493712, 44.494698, 44.495026], difficulty: .intermediate),
                                                                                                        "Waterfall" : (coordinates: [44.491897, 44.491613, 44.491675, 44.492827, 44.493562, 44.494792, 44.496174, 44.496782, 44.497382, 44.498290, 44.498482], difficulty: .intermediate),
                                                                                                        "Sunrise" : (coordinates: [44.491897, 44.492065, 44.492453, 44.493013, 44.493724, 44.494262, 44.494567, 44.494555, 44.494411, 44.494411, 44.494824, 44.498290, 44.498482], difficulty: .intermediate),
                                                                                                        "Cruiser" : (coordinates: [44.492065, 44.492453, 44.493013, 44.493724, 44.494262, 44.494567, 44.494555, 44.494821, 44.494962, 44.498667, 44.498482], difficulty: .intermediate),
                                                                                                        "Tranquility" : (coordinates: [44.497017, 44.497236, 44.497863, 44.498626, 44.499092, 44.499694, 44.501901, 44.502168, 44.502297], difficulty: .intermediate),
                                                                                                        "Smart Alec" : (coordinates: [44.497017, 44.497236, 44.497657, 44.498075, 44.498203, 44.498317, 44.499322, 44.500428, 44.502544, 44.502297], difficulty: .intermediate),
                                                                                                        "Yahoo" : (coordinates: [44.497017, 44.497236, 44.497657, 44.498075, 44.498203, 44.499210, 44.499675, 44.500092, 44.500384, 44.500428, 44.502544, 44.502297], difficulty: .intermediate),
                                                                                                        "Village Way" : (coordinates: [44.497017, 44.497236, 44.497657, 44.497882, 44.498179, 44.498766, 44.499263, 44.499722, 44.499896, 44.500772, 44.501394, 44.502535, 44.502710, 44.502907, 44.502737, 44.502544, 44.502297], difficulty: .intermediate),
                                                                                                        "Legacy" : (coordinates: [44.501740, 44.501169, 44.501530, 44.501054, 44.500899, 44.500908, 44.501650, 44.502994, 44.504225, 44.505359, 44.505881], difficulty: .intermediate),
                                                                                                        "Apple Bowl" : (coordinates: [44.501740, 44.501169, 44.501530, 44.501971, 44.501982, 44.504225, 44.505359, 44.505881], difficulty: .intermediate),
                                                                                                        "Going South" : (coordinates: [44.504817, 44.504737, 44.504751, 44.504081, 44.503875, 44.503953, 44.504728, 44.505129, 44.505549, 44.506226, 44.505881], difficulty: .intermediate),
                                                                                                        "Dog Sled" : (coordinates: [44.504728, 44.505095, 44.505536, 44.506382, 44.506913, 44.508692, 44.509823, 44.509956], difficulty: .intermediate),
                                                                                                        "Schuss" : (coordinates: [44.504817, 44.505266, 44.505307, 44.505342, 44.505652, 44.506881, 44.507349, 44.508227, 44.509336, 44.510107, 44.510541, 44.510454, 44.510295, 44.509956], difficulty: .intermediate),
                                                                                                        "L-Hill" : (coordinates: [44.497017, 44.496610, 44.496416, 44.496235, 44.496370, 44.496595, 44.496785, 44.497219, 44.497966, 44.499091, 44.500120, 44.501330, 44.501896, 44.502168, 44.502297], difficulty: .intermediate),
                                                                                                        "Susan's Hideaway" : (coordinates: [44.497017, 44.496610, 44.496416, 44.496235, 44.496042, 44.495656, 44.495508, 44.495319, 44.495095, 44.495156, 44.495312, 44.495756, 44.496804, 44.497301, 44.497966, 44.499091, 44.500120, 44.501330, 44.501896, 44.502168, 44.502297], difficulty: .intermediate),
                                                                                                        "Dr. Doug" : (coordinates: [44.491897, 44.492065, 44.492453, 44.493013, 44.493724, 44.494262, 44.494567, 44.495114, 44.495820, 44.496196, 44.496845, 44.497049, 44.497792, 44.498133, 44.498114, 44.498011, 44.498100, 44.498591, 44.498657, 44.498667, 44.498482], difficulty: .intermediate),
                                                                                                        "Crooked Oak" : (coordinates: [44.491897, 44.491613, 44.491675, 44.492827, 44.493300, 44.493686, 44.494967, 44.496174, 44.496782, 44.497382, 44.498290, 44.498482], difficulty: .advanced),
                                                                                                        "Calamity Lane" : (coordinates: [44.501740, 44.501169, 44.501530, 44.501971, 44.502367, 44.503046, 44.504225, 44.505359, 44.505881], difficulty: .advanced),
                                                                                                        "Willy's" : (coordinates: [44.501740, 44.501549, 44.502315, 44.502713, 44.502994, 44.503544, 44.504170, 44.505549, 44.506226, 44.505881], difficulty: .advanced),
                                                                                                        "Hog's Back" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505139, 44.505088, 44.504900, 44.504844, 44.504702, 44.505115, 44.505701, 44.506363, 44.506913, 44.508692, 44.509823, 44.509956], difficulty: .advanced),
                                                                                                        "Senator / Larway" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505295, 44.505593, 44.505827, 44.506287, 44.506705, 44.507132, 44.509410, 44.510035, 44.510118, 44.510295, 44.509956], difficulty: .advanced),
                                                                                                        "Rabbits Run" : (coordinates: [44.504817, 44.505266, 44.505709, 44.506068, 44.506497, 44.506946, 44.507125, 44.507906, 44.508852, 44.510003, 44.510541, 44.510454, 44.510295, 44.509956], difficulty: .advanced),
                                                                                                        "Kandahar" : (coordinates: [44.504817, 44.505266, 44.505307, 44.505342, 44.505652, 44.505888, 44.506054, 44.506655, 44.507177, 44.508005, 44.508501, 44.508864, 44.509083, 44.509435, 44.509823, 44.509978, 44.510032, 44.510179, 44.510122, 44.510107, 44.510541, 44.510454, 44.510295, 44.509956], difficulty: .advanced),
                                                                                                        "Dieppe" : (coordinates: [44.504817, 44.505266, 44.505307, 44.505342, 44.505652, 44.505888, 44.506054, 44.506655, 44.507065, 44.507522, 44.508129, 44.508886, 44.508944, 44.509083, 44.509435, 44.509823, 44.509978, 44.510032, 44.510179, 44.510122, 44.510107, 44.510541, 44.510454, 44.510295, 44.509956], difficulty: .advanced),
                                                                                                        "Memory Lane" : (coordinates: [44.497017, 44.496610, 44.496621, 44.496730, 44.496956, 44.497246, 44.497451, 44.497625, 44.497967, 44.500120, 44.501330, 44.501896, 44.502168, 44.502297], difficulty: .advanced),
                                                                                                        "Rinus Run" : (coordinates: [44.497017, 44.496610, 44.496621, 44.496730, 44.496956, 44.497246, 44.497451, 44.497625, 44.497967, 44.497848, 44.497653, 44.499091, 44.500120, 44.501330, 44.501896, 44.502168, 44.502297], difficulty: .advanced),
                                                                                                        "Burner" : (coordinates: [44.501740, 44.501549, 44.502315, 44.502444, 44.502727, 44.502743, 44.502719, 44.502719, 44.502748, 44.502825, 44.502941, 44.503076, 44.503183, 44.503226, 44.503132, 44.503142, 44.503434, 44.503490, 44.503657, 44.504025, 44.504225, 44.505359, 44.505881], difficulty: .advanced),
                                                                                                        "Elevator Shaft" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505139, 44.505088, 44.505246, 44.505572, 44.506662, 44.507236, 44.508692, 44.509823, 44.509956], difficulty: .expert),
                                                                                                        "Avalanche" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505139, 44.505671, 44.506142, 44.506575, 44.507305, 44.508692, 44.509823, 44.509956], difficulty: .expert),
                                                                                                        "Spectacular" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505139, 44.505671, 44.506816, 44.508281, 44.508692, 44.509823, 44.509956], difficulty: .expert),
                                                                                                        "Little Devil" : (coordinates: [44.504817, 44.504737, 44.504960, 44.505046, 44.505139, 44.505671, 44.505779, 44.506027, 44.506651, 44.508849, 44.510295, 44.509956], difficulty: .expert),
                                                                                                        "Lone Rider" : (coordinates: [44.504817, 44.505266, 44.505709, 44.506350, 44.506975, 44.507537, 44.508162, 44.508759, 44.509246, 44.509841, 44.510454, 44.510295, 44.509956], difficulty: .expert),
                                                                                                        "Starting Gate" : (coordinates: [44.504817, 44.505266, 44.505709, 44.506068, 44.506497, 44.506946, 44.507364, 44.507984, 44.509039, 44.510541, 44.510454, 44.510295, 44.509956], difficulty: .expert),
                                                                                                        "Badlands Terrain Park" : (coordinates: [44.490826, 44.491339, 44.492060, 44.492420, 44.492592, 44.492812, 44.492847, 44.493233, 44.493669, 44.493787, 44.494233, 44.494008, 44.493761, 44.493438, 44.493135, 44.492925, 44.492748, 44.492518, 44.492168, 44.491792, 44.491478, 44.491292, 44.491101, 44.490826], difficulty: .terrainPark)]

    // MARK: - Lifecycle Functions
    init() {
        self.lifts = blueMountainReport?.mountainAreas.flatMap({ $0.lifts }) ?? []
        self.trails = blueMountainReport?.mountainAreas.flatMap({ $0.trails }) ?? []
    }
}

extension BlueMountainTrailViewModel: CoordinatesViewModelable {
    var defaultViewCoordinates: (lat: Double, long: Double) {
        return (44.501836, -80.318000)
    }
    
    var trailCoordinates: [TrailSegment] {
        var trailSegments = [TrailSegment]()

        for trail in trails {
            guard let longCoordinates = trailLongCoordinates[trail.name], let latCoordinates = trailLatCoordinates[trail.name], let trailStatus = TrailSegment.Status(rawValue: trail.status.lowercased()) else {
                continue
            }
            
            for index in 0 ..< longCoordinates.coordinates.count-1 {
                let segment = TrailSegment(name: trail.name, status: trailStatus, latStart: latCoordinates.coordinates[index], latEnd: latCoordinates.coordinates[index+1], longStart: longCoordinates.coordinates[index], longEnd: longCoordinates.coordinates[index+1], difficulty: longCoordinates.difficulty)
                trailSegments.append(segment)
            }
        }
        
        for lift in lifts {
            guard let longCoordinates = liftLongCoordinates[lift.name], let latCoordinates = liftLatCoordinates[lift.name], let trailStatus = TrailSegment.Status(rawValue: lift.status.lowercased()) else {
                continue
            }
            
            for index in 0 ..< longCoordinates.count-1 {
                let segment = TrailSegment(name: lift.name, status: trailStatus, latStart: latCoordinates[index], latEnd: latCoordinates[index+1], longStart: longCoordinates[index], longEnd: longCoordinates[index+1], difficulty: .unknown)
                trailSegments.append(segment)
            }
        }
        return trailSegments
    }
    
    var lodgeCoordinates: [LodgeInfo] {
        return [LodgeInfo(title: "South Base Lodge", lat: 44.497715, long: -80.307308),
                LodgeInfo(title: "Grand Central Lodge", lat: 44.502934, long: -80.313855),
                LodgeInfo(title: "Inn Base Lodge", lat: 44.506529, long: -80.317523)]
    }
}
