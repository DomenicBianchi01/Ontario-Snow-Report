//
//  BlueMountainInfoDataProvider.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class BlueMountainInfoDataProvider {}

extension BlueMountainInfoDataProvider: MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void) {
        blueMountainReport = nil
        
        guard let url = URL(string: "https://snowreporting.herokuapp.com/feed?resortId=3") else {
            completion()
            return
        }
        do {
            let jsonString = try String(contentsOf: url, encoding: .ascii)
            if let jsonData = jsonString.data(using: .utf8) {
                blueMountainReport = try JSONDecoder().decode(BlueData.self, from: jsonData)
            }
        }
        catch {}
        completion()
    }
}
