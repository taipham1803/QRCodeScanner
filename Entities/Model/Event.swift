//
//  Event.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/16/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Event{
    let eventTitle: String
    let eventLocation: String
    let startTime: Date
    let endTime: Date
    
    init(eventTitle: String, eventLocation: String, startTime: Date, endTime: Date) {
        self.eventTitle = eventTitle
        self.eventLocation = eventLocation
        self.startTime = startTime
        self.endTime = endTime
    }
}
