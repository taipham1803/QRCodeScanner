//
//  ConstantManager.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/8/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

enum ConstantManager {
    
    struct AppInfo {
        static let versionNumber = 100
        static let defaultUpdate = 1551398400
    }
    
    enum Segue: String {
        case segueGenerateToText = "segueGenerateToText"

    }
    
    enum RegexValidate: String {
        case mailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        case youtubeRegex = "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})"
        case facebookRegEx = "(http(s)?:\\/\\/)?(www\\.|m\\.)?f(acebook\\.com|b\\.com)"
    }
    
    enum Color {
        case appColor
        
        var color: UIColor {
            switch self {
            case .appColor:
                return #colorLiteral(red: 1, green: 0.5333333333, blue: 0.6745098039, alpha: 1)
            }
        }
        
    }
    
    struct NotificationName {
        static let reachable = Foundation.Notification.Name("Reachable")
        static let unreachable = Foundation.Notification.Name("Unreachable")
    }
    
    enum Key {
        
        case apiKey
        
        var value: String {
            #if DEBUG
            return "poiuytrewq19"
            #else
            return "poiuytrewq"
            #endif
        }
        
    }
    
}
