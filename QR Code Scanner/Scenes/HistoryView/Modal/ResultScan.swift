//
//  ResultScan.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/1/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

struct ResultScan{
    var typeId: Int = 0
    var name: String = ""
    var content: String = ""
    
    init(typeId: Int?, name: String?, content: String?) {
        self.typeId = typeId ?? 0
        self.name = name ?? ""
        self.content = content ?? ""
    }
}
