//
//  Email.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/16/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation

class Email{
    let yourEmail: String
    let subject: String
    let message: String
    
    init(yourEmail: String, subject: String, message: String) {
        self.yourEmail = yourEmail
        self.subject = subject
        self.message = message
    }
    
    init() {
        self.yourEmail = ""
        self.subject = ""
        self.message = ""
    }
}
