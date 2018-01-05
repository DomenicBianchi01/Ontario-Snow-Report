//
//  HorseshoeDataProvider.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-22.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class HorseshoeDataProvider {}

extension HorseshoeDataProvider: MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void) {
        blueMountainReport = nil
        parsedReport = nil
        mountainDetails = nil
        
        guard let url = URL(string: "https://horseshoeresort.com/ski-report-trails/") else {
            completion()
            return
        }
        
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            parsedReport = try SwiftSoup.parse(html)
            mountainDetails = try parsedReport?.getElementsByClass("report-table")
        }
        catch {}
        
        completion()
    }
}
