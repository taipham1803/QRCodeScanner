//
//  Wifi.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Wifi{
    var name: String
    var password: String
    var encryption: String
    
    init(name: String, password: String, encryption: String) {
        self.name = name
        self.password = password
        self.encryption = encryption
    }
}
