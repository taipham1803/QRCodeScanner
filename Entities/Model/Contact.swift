//
//  Contact.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/16/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Contact{
    let firstName: String
    let lastName: String
    let company: String
    let phoneNumber: String
    let note: String
    
    init(firstName: String, lastName: String, company: String, phoneNumber: String, note: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.phoneNumber = phoneNumber
        self.note = note
    }
}
