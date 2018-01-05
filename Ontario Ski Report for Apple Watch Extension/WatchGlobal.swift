//
//  WatchGlobal.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

// MARK: - Global Properties
var parsedReport: Document? = nil
var mountainDetails: Elements? = nil
var blueMountainReport: BlueData? = nil
