//
//  GlenEdenLiftInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-12-25.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class GlenEdenLiftInfoViewModel {
    // MARK: - Properties
    private var liftNumber = 0
    private var lifts: [Element]? = nil
    
    // MARK: - Lifecycle Functions
    init(for liftNumber: Int) {
        self.liftNumber = liftNumber * 3
        do {
            self.lifts = try mountainDetails?.get(3).getElementsByTag("td").filter({ !$0.hasAttr("colspan") })
        } catch {}
    }
}

extension GlenEdenLiftInfoViewModel: TitleViewModelable {
    var title: String {
        do {
            return try lifts?[liftNumber+1].text() ?? ""
        } catch {
            return ""
        }
    }
}

extension GlenEdenLiftInfoViewModel: DescriptionViewModelable {
    var description: String {
        do {
            let status = try lifts?[liftNumber].text() ?? ""
            if status.lowercased() == "open" {
                return "Open"
            }
            return "Closed"
        } catch {
            return "Unknown"
        }
    }
}

extension GlenEdenLiftInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        do {
            let status = try lifts?[liftNumber].text() ?? ""
            if status.lowercased() == "open" {
                return [#imageLiteral(resourceName: "Checkmark")]
            } else {
                return [#imageLiteral(resourceName: "X")]
            }
        } catch {
            return []
        }
    }
}
