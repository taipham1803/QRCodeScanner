//
//  MasterManager.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/20/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class MasterDataManager {
    
    static let shared = MasterDataManager()
    
    private init() {}
    
    let arrayGenerateType:[Scan] = [
        Scan(id: 1, content: "Website", type: "website"),
        Scan(id: 2, content: "Contact", type: "contact"),
        Scan(id: 3, content: "Plain text", type: "text"),
        Scan(id: 4, content: "Phone number", type: "phoneNumber"),
        Scan(id: 5, content: "Email", type: "email"),
        Scan(id: 6, content: "Link URL", type: "url"),
        Scan(id: 7, content: "Location", type: "location"),
        Scan(id: 8, content: "Event information", type: "event"),
        Scan(id: 9, content: "SMS", type: "sms"),
        Scan(id: 10, content: "Wifi", type: "wifi")
    ]

    
}
