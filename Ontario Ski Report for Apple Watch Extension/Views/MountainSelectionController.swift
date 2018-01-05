//
//  MountainSelectionController.swift
//  Ontario Ski Report For Apple Watch Extension
//
//  Created by Domenic Bianchi on 2017-12-29.
//  Copyright © 2017 Domenic Bianchi. All rights reserved.
//

import WatchKit

final class MountainSelectionController: WKInterfaceController {
    // MARK: - IBOutlets
    @IBOutlet var mountainTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        mountainTable.setNumberOfRows(4, withRowType: "MountainRow")
        
        for index in 0..<4 {
            guard let controller = mountainTable.rowController(at: index) as? MountainRowController else { continue }
            
            controller.mountain = Mountain(rawValue: index) ?? .blueMountain
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        presentController(withName: "MountainInfo", context: Mountain(rawValue: rowIndex) ?? .blueMountain)
    }
}
