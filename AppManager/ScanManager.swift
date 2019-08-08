//
//  ScanManager.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/8/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class ScanManager {
    
    static let shared = ScanManager()
    
    private init() {}
    
    var status: Status = .scan
    fileprivate(set) var historyScan: [Scan] = []
    
    enum Status {
        case scan
        case generate
        case history
    }
    
    func saveNewScanResult(scan: Scan){
        if self.historyScan.contains(where: { $0.content == scan.content }) == false {
            self.historyScan.append(scan)
        }
//        self.historyScan.append(scan)
    }
    
}
