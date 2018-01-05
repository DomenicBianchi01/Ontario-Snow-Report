//
//  HorseshoeLiftInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-11-26.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class HorseshoeLiftInfoViewModel {
    // MARK: - Properties
    private var lift: Elements? = nil
    private var liftNumber = 0
    
    // MARK: - Lifecycle Functions
    init(for liftNumber: Int) {
        self.liftNumber = liftNumber * 3
        do {
            self.lift = try mountainDetails?.get(4).getElementsByTag("td")
        } catch {}
    }
}

extension HorseshoeLiftInfoViewModel: TitleViewModelable {
    var title: String {
        do {
            return try lift?.get(liftNumber).text() ?? ""
        } catch {
            return ""
        }
    }
}

extension HorseshoeLiftInfoViewModel: DescriptionViewModelable {
    var description: String {
        do {
            let status = try lift?.get(liftNumber+1).text() ?? ""
            if status.lowercased() == "open" {
                return "Open"
            }
            return "Closed"
        } catch {
            return ""
        }
    }
}

extension HorseshoeLiftInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        do {
            let status = try lift?.get(liftNumber+1).text() ?? ""
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
