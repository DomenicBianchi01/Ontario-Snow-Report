//
//  TodayMountainInfoDataProvider.swift
//  Today's Ski Report
//
//  Created by Domenic Bianchi on 2017-12-28.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class TodayMountainInfoDataProvider {}

extension TodayMountainInfoDataProvider: MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void) {
        blueMountainReport = nil
        mtSaintLouisDetails = nil
        mtSaintLouisFullReport = nil
        horseshoeFullReport = nil
        horseshoeDetails = nil
        
        let urlStrings = ["https://snowreporting.herokuapp.com/feed?resortId=3", //Blue Mountain
                    "https://mountstlouis.com/open-runs-day/", // Mt. St. Louis
                    "https://mountstlouis.com/open-parks/", // Mt. St. Louis
                    "https://horseshoeresort.com/ski-report-trails/", // Horseshoe Valley
                    "https://gleneden.on.ca/conditions"] // Glen Eden
        
        for (index, urlString) in urlStrings.enumerated() {
            guard let url = URL(string: urlString) else {
                completion()
                return
            }
            if index == 0 {
                fetchBlueMountainJSON(from: url)
            } else if index == 1 {
                fetchSaintLouisHTML(from: url)
            } else if index == 2 {
                fetchSaintLouisHTML(from: url, appendToCurrentDetails: true)
            } else if index == 3 {
                fetchHorseshoeHTML(from: url)
            } else if index == 4 {
                fetchGlenEdenHTML(from: url)
            }
        }
        completion()
    }
    
    // MARK: - Helper Functions
    private func fetchBlueMountainJSON(from url: URL) {
        do {
            let jsonString = try String(contentsOf: url, encoding: .ascii)
            if let jsonData = jsonString.data(using: .utf8) {
                blueMountainReport = try JSONDecoder().decode(BlueData.self, from: jsonData)
            }
        } catch {}
    }
    
    private func fetchSaintLouisHTML(from url: URL, appendToCurrentDetails: Bool = false) {
        do {
            let html = try String(contentsOf: url, encoding: .ascii)

            if appendToCurrentDetails {
                try mtSaintLouisFullReport?.append(html)
                mtSaintLouisDetails = try mtSaintLouisFullReport?.getElementsByClass("availability_list table")
                
                // The app currently does not use data for night operastions
                if let newDetails = mtSaintLouisDetails?.dropLast(2) {
                    mtSaintLouisDetails = Elements(Array(newDetails))
                }
            } else {
                mtSaintLouisFullReport = try SwiftSoup.parse(html)
                mtSaintLouisDetails = try mtSaintLouisFullReport?.getElementsByClass("availability_list table")
            }
        }
        catch {}
    }
    
    private func fetchHorseshoeHTML(from url: URL) {
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            horseshoeFullReport = try SwiftSoup.parse(html)
            horseshoeDetails = try horseshoeFullReport?.getElementsByClass("report-table")
        }
        catch {}
    }
    
    private func fetchGlenEdenHTML(from url: URL) {
        do {
            let html = try String(contentsOf: url, encoding: .ascii)
            glenEdenDetails = try SwiftSoup.parse(html).getElementsByTag("table")
        } catch {}
    }
}
