//
//  MountainInfoDataProvidable.swift
//  Ontario Ski Report
//
//  Created by Domenic Bianchi on 2017-09-22.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import Foundation

protocol MountainInfoDataProvidable {
    func fetchMountainInfo(with completion: @escaping () -> Void)
}
