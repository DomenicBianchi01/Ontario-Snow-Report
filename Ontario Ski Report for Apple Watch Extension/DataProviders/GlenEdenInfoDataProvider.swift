//
//  GlenEdenInfoDataProvider.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class GlenEdenInfoDataProvider {}

extension GlenEdenInfoDataProvider: MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void) {
        blueMountainReport = nil
        parsedReport = nil
        mountainDetails = nil
        
        guard let url = URL(string: "https://gleneden.on.ca/conditions") else {
            completion()
            return
        }
        
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            parsedReport = try SwiftSoup.parse(html)
            mountainDetails = try parsedReport?.getElementsByTag("table")
        }
        catch {}
        
        completion()
    }
}

