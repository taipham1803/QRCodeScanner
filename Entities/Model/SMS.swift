//
//  SMS.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/16/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class SMS{
    let yourPhone: String
    let message: String
    
    init(yourPhone: String, message: String) {
        self.yourPhone = yourPhone
        self.message = message
    }
}
