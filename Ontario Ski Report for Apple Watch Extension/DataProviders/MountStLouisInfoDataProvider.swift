//
//  MountStLouisInfoDataProvider.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class MountStLouisInfoDataProvider {}

extension MountStLouisInfoDataProvider: MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void) {
        blueMountainReport = nil
        parsedReport = nil
        mountainDetails = nil
        
        fetchHTML(from: "https://mountstlouis.com/open-runs-day/", completion: completion)
        fetchHTML(from: "https://mountstlouis.com/open-parks/", appendToCurrentDetails: true, completion: completion)
        completion()
    }
    
    private func fetchHTML(from url: String, appendToCurrentDetails: Bool = false, completion: () -> Void) {
        guard let url = URL(string: url) else {
            completion()
            return
        }
        
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            
            if appendToCurrentDetails {
                try parsedReport?.append(html)
                mountainDetails = try parsedReport?.getElementsByClass("availability_list table")
                
                // The app currently does not use data for night operastions
                if let newDetails = mountainDetails?.dropLast(2) {
                    mountainDetails = Elements(Array(newDetails))
                }
            } else {
                parsedReport = try SwiftSoup.parse(html)
                mountainDetails = try parsedReport?.getElementsByClass("availability_list table")
            }
        }
        catch {}
    }
}
