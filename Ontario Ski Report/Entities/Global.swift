//
//  Global.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

// MARK: - Global Properties
var selectedMountain: Mountain = .blueMountain
var parsedReport: Document? = nil
var mountainDetails: Elements? = nil
var blueMountainReport: BlueData? = nil
