//
//  MountStLouisLiftInfoViewModel.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-19.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation
import SwiftSoup

final class MountStLouisLiftInfoViewModel {
    // MARK: - Properties
    private var liftNumber = 0
    private var liftGroup: Element?
    
    // MARK: - Lifecycle Functions
    init(for liftNumber: Int) {
        self.liftNumber = liftNumber
        
        do {
            if let liftCopy = mountainDetails?.get(2).copy() as? Element {
                self.liftGroup = try liftCopy.append(mountainDetails?.get(3).html() ?? "")
            }
        } catch {}
    }
}

extension MountStLouisLiftInfoViewModel: TitleViewModelable {
    var title: String {
        do {
            return try liftGroup?.select(".title").array()[liftNumber].text() ?? ""
        } catch {
            return ""
        }
    }
}

extension MountStLouisLiftInfoViewModel: DescriptionViewModelable {
    var description: String {
        do {
            let status = try liftGroup?.select(".status").array()[liftNumber].text()
            if status == "Open" {
                return try liftGroup?.select(".status").array()[liftNumber].text() ?? ""
            }
            return "Closed"
        } catch {
            return ""
        }
    }
}

extension MountStLouisLiftInfoViewModel: ImagesViewModelable {
    var images: [UIImage] {
        do {
            let status = try liftGroup?.select(".status").array()[liftNumber].text() ?? ""
            if status == "Open" {
                return [#imageLiteral(resourceName: "Checkmark")]
            } else {
                return [#imageLiteral(resourceName: "X")]
            }
        } catch {
            return []
        }
    }
}
