//
//  ScanModel.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/8/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Scan{
    let id: Int
    let content: String
    let type: String
    
    init(id: Int, content: String, type: String) {
        self.id = id
        self.content = content
        self.type = type
    }
}
