//
//  Location.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Location{
    let yourAddress: String
    let latitude: String
    let longitude: String
    
    init(yourAddress: String, latitude: String, longitude: String) {
        self.yourAddress = yourAddress
        self.latitude = latitude
        self.longitude = longitude
    }
}
