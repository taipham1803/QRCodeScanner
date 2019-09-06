//
//  ScanManager.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/8/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData
import NetworkExtension

//extension StringProtocol { // for Swift 4.x syntax you will needed also to constrain the collection Index to String Index - `extension StringProtocol where Index == String.Index`
//    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
//        return range(of: string, options: options)?.lowerBound
//    }
//    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
//        return range(of: string, options: options)?.upperBound
//    }
//    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
//        var result: [Index] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...].range(of: string, options: options) {
//                result.append(range.lowerBound)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
//    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
//        var result: [Range<Index>] = []
//        var startIndex = self.startIndex
//        while startIndex < endIndex,
//            let range = self[startIndex...].range(of: string, options: options) {
//                result.append(range)
//                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
//                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        return result
//    }
//}

class ScanManager {
    
    static let shared = ScanManager()
    
    var originText = ""
    var detectedObject: Any?
    var typeContentScan = ""
    
    private init() {
        self.originText = ""
        self.detectedObject = ""
        self.typeContent = TypeContent.text("")
        self.typeContentGen = TypeContentGen.text
    }
    
    var status: Status = .scan
    fileprivate(set) var typeContentGen: TypeContentGen
    fileprivate(set) var typeContent: TypeContent
    fileprivate(set) var historyScan: [Scan] = []
    fileprivate(set) var contentGenerate: String?
    fileprivate(set) var contentGenerateEmail: Email?
    fileprivate(set) var contentGenerateSMS: SMS?
    fileprivate(set) var contentGenerateContact: Contact?
    fileprivate(set) var contentGenerateEvent: Event?
    fileprivate(set) var contentGenerateWifi: Wifi?
    fileprivate(set) var contentGenerateLocation: Location?
    
    enum Status {
        case scan
        case generate
        case history
    }
    
    enum TypeContentGen {
        case text
        case email
        case contact
        case location
        case event
        case sms
        case wifi
        case phoneNumber
        case website
        case url
        case instagram
        case youtube
    }
    
    enum TypeContent {
        case text(String)
        case email(Email)
        case contact(Contact)
        case location(Location)
        case event(Event)
        case sms(SMS)
        case wifi(Wifi)
        case phoneNumber(String)
        case website(String)
        case url(String)
        case instagram(String)
        case youtube(String)
//        case instagram(String)
        
        var action: [Action] {
            switch self {
            case .text(let str):
                return [.copy(str), .safari(str), .chrome(str), .share(str)]
            case .email(let email):
                return [.copy(email.message), .safari(email.message), .openMail(email.message), .share(email.message)]
            case .contact(let contact):
//                let sms = SMS.init(yourPhone: contact.phoneNumber, message: contact.note)
                return [.copy(contact.phoneNumber), .message(contact.phoneNumber), .callPhone(contact.phoneNumber), .share(contact.phoneNumber)]
            case .event(let event):
                return [.copy(event.eventTitle), .safari(event.eventTitle), .chrome(event.eventTitle), .share(event.eventTitle)]
            case .location(let location):
                return [.copy(location.yourAddress), .safari(location.yourAddress), .openMap(location),  .share(location.yourAddress)]
            case .phoneNumber(let phone):
//                let sms = SMS.init(yourPhone: phone, message: "your message")
                return [.copy(phone), .message(phone), .callPhone(phone), .share(phone)]
            case .sms(let sms):
                return [.copy(sms.message), .callPhone(sms.yourPhone), .message(sms.message), .share(sms.message)]
            case .url(let url):
                return [.copy(url), .safari(url), .chrome(url), .share(url)]
            case .website(let website):
                return [.copy(website), .safari(website), .chrome(website), .share(website)]
            case .wifi(let wifi):
                return [.copy(wifi.name + wifi.password + wifi.encryption), .safari(wifi.name), .openWifi(wifi), .share(wifi.name)]
            case .instagram(let user):
                return [.copy(user), .safari(user), .openInstagram(user), .share(user)]
            case .youtube(let link):
                return [.copy(link), .safari(link), .youtube(link), .share(link)]
            }
        }
    }
    
    enum Action {
        case copy(String)
        case share(String)
        case safari(String)
        case chrome(String)
        case youtube(String)
        case facebook(String)
        case openWifi(Wifi)
        case openMail(String)
        case message(String)
        case callPhone(String)
        case openMap(Location)
        case openInstagram(String)
        
        var icon: UIImage? {
            switch self {
            case .copy:
                return UIImage.init(named: "copy")
            case .share:
                return UIImage.init(named: "share")
            case .safari:
                return UIImage.init(named: "safari")
            case .chrome:
                return UIImage.init(named: "chrome")
            case .youtube:
                return UIImage.init(named: "youtube")
            case .facebook:
                return UIImage.init(named: "facebook")
            case .openWifi:
                return UIImage.init(named: "wifi")
            case .openMail:
                return UIImage.init(named: "gmail")
            case .message:
                return UIImage.init(named: "imessage")
            case .callPhone:
                return UIImage.init(named: "phonenumber")
            case .openMap:
                return UIImage.init(named: "map")
            case .openInstagram:
                return UIImage.init(named: "instagram")
            }
        }
        
        func action() {
            switch self {
            case .copy(let str):
                let pasteboard = UIPasteboard.general
//                displayToastMessage("Copied to clipboard")
                pasteboard.string = str
                break
            case .share(let string):
                let text = string
                func topViewController()-> UIViewController{
                    var topViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                    while ((topViewController.presentedViewController) != nil) {
                        topViewController = topViewController.presentedViewController!;
                    }
                    return topViewController
                }
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = topViewController().view
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
                topViewController().present(activityViewController, animated: true, completion: nil)
            case .safari(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .chrome(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .youtube(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .facebook(let PROFILE_ID2):
                let PROFILE_ID = "taipham1803"
                if UIApplication.shared.canOpenURL(URL(string: "fb://profile/" + PROFILE_ID)!) {
                    UIApplication.shared.open(URL(string: "fb://profile/PROFILE_ID")!, options: [:])
                } else {
                    UIApplication.shared.open(URL(string: "https://facebook.com/" + PROFILE_ID)!, options: [:])
                }
                
//                guard let url = URL(string: str) else { return }
//                UIApplication.shared.open(url)
            case .openWifi(let wifi):
                print("Connecting to Wifi name: ",wifi.name, wifi.password )
                let configuration = NEHotspotConfiguration.init(ssid: wifi.name, passphrase: wifi.password, isWEP: false)
                configuration.joinOnce = true
                
                NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
                    if error != nil {
                        if error?.localizedDescription == "already associated."
                        {
                            print("Connected")
                        }
                        else{
                            print("No Connected")
                        }
                    }
                    else {
                        print("Connected")
                    }
                }
            case .openMail(let email):
                guard let email = URL(string: email) else { return }
                UIApplication.shared.open(email)
            case .message(let message):
                guard let message = URL(string: message) else { return }
                UIApplication.shared.open(message)
            case .callPhone(let phone):
                guard let phone = URL(string: phone) else { return }
                UIApplication.shared.open(phone)
            case .openMap(let location):
//                guard let location = URL(string: location.yourAddress) else { return }
//                UIApplication.shared.open(location)
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(location.latitude),\(location.longitude)&zoom=14&views=traffic")!)
            case .openInstagram(let instagram):
                let startId = instagram.range(of: "m/")
                let endId = instagram.range(of: "?")
                let startIdReal = instagram.index(startId!.lowerBound, offsetBy: 2)
                let Username = instagram[startIdReal..<endId!.lowerBound]
                
//                let Username = "minhoangtan"
                let appURL = URL(string: "instagram://user?username=\(Username)")!
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL) {
                    application.open(appURL)
                } else {
                    // if Instagram app is not installed, open URL inside Safari
                    let webURL = URL(string: "https://instagram.com/\(Username)")!
                    application.open(webURL)
                }
            }
        }
    }
    
        //    https://instagram.com/minhoangtan?igshid=q5zwpd03lyea
    
    func openFacebook(facebookUrl: String) {
        guard let url = URL(string: facebookUrl)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    

    
    public func setOriginText(originText: String){
        self.originText = originText
    }
    
    func substring(string: String, fromIndex: Int, toIndex: Int) -> String? {
        if fromIndex < toIndex && toIndex < string.count /*use string.characters.count for swift3*/{
            let startIndex = string.index(string.startIndex, offsetBy: fromIndex)
            let endIndex = string.index(string.startIndex, offsetBy: toIndex)
            return String(string[startIndex..<endIndex])
        }else{
            return nil
        }
    }
    
    func filterWifi(content: String) -> Wifi{
        let saveOriginText = content
        let contentUse = content.lowercased()
        guard let startSSID = contentUse.range(of: "s:") else { return Wifi.init(name: content, password: "", encryption: "")}
        
        let subStringSSID = contentUse[startSSID.lowerBound...]
        let originSubStringSSID = saveOriginText[startSSID.lowerBound...]
        
        guard let endSSID = subStringSSID.range(of: ";") else { return Wifi.init(name: content, password: "", encryption: "") }
        
        let startSSIDReal = subStringSSID.index(startSSID.lowerBound, offsetBy: 2)
        let SSID = originSubStringSSID[startSSIDReal..<endSSID.lowerBound]

        guard let startPassword = contentUse.range(of: "p:") else {return Wifi.init(name: content, password: "", encryption: "")}
        
        let subStringPass = contentUse[startPassword.lowerBound...]
        let originSubStringPass = saveOriginText[startPassword.lowerBound...]
        
        guard let endPassword = subStringPass.range(of: ";") else {return Wifi.init(name: content, password: "", encryption: "")}
        
        let startPasswordReal = subStringPass.index(startPassword.lowerBound, offsetBy: 2)
        let password = originSubStringPass[startPasswordReal..<endPassword.lowerBound]
        
        print("SSID:", SSID)
        print("Password:", password)
        return Wifi.init(name: String(SSID), password: String(password), encryption: "WPA2")
    }
    
    func filterLocation(content: String) -> Location{
        let contentUse = content
        guard let startLat = contentUse.range(of: "q=") else {
            return Location.init(yourAddress: content, latitude: "", longitude: "")
        }
        guard let endLat = contentUse.range(of: ",") else {
            return Location.init(yourAddress: content, latitude: "", longitude: "")
        }
        let startLatReal = contentUse.index(startLat.lowerBound, offsetBy: 2)
        let latitude = contentUse[startLatReal..<endLat.lowerBound]
        
        let startLongitudeReal = contentUse.index(endLat.lowerBound, offsetBy: 2)
        let longitude = contentUse[startLongitudeReal...]
        
        print("Latitude:", latitude)
        print("longitude:", longitude)
        
        return Location.init(yourAddress: contentUse, latitude: String(latitude), longitude: String(longitude))
    }
    

    
    public func scan(originText: String) -> TypeContent {
        let saveOriginText = originText
        let contentUse = originText.lowercased()
        if(contentUse.prefix(6).contains("tel:")){
            typeContentScan = "Phone Number"
            return .phoneNumber(contentUse)
        } else if(contentUse.prefix(6).contains("wifi")){
            //  var stringMap = WIFI:S:Emddi;T:WPA;P:@emddi2018;;
            typeContentScan = "WIFI"
            return .wifi(filterWifi(content: saveOriginText))
        } else if(contentUse.prefix(6).contains("smsto:")){
            typeContentScan = "SMS"
            let sms = SMS.init(yourPhone: "0869898203", message: "ahihi do ngok")
            return .sms(sms)
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.mailRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "Email"
            let email = Email.init(yourEmail: "", subject: "", message: contentUse)
            return .email(email)
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.youtubeRegex.rawValue, in: contentUse).count>0){
            typeContentScan = "Youtube"
            return .youtube(contentUse)
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.facebookRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "Facebook"
            return .url(contentUse)
        } else if(contentUse.prefix(40).contains("instagram")){
            typeContentScan = "Instagram"
            return .instagram(contentUse)
        } else if(contentUse.prefix(40).contains("maps.google.com") || contentUse.prefix(40).contains("www.google.com/maps")){
            typeContentScan = "Google Map"
            //  var stringMap = https://maps.google.com/local?q=21.041591672828975,105.89360720219906
            return .location(filterLocation(content: contentUse))
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.urlRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "URL"
            return .text(contentUse)
        } else {
            typeContentScan = "Text"
            return .text(contentUse)
        }
    }
    
    func checkTypeContent(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            print("\(results)")
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func setTypeContentText(){
        self.typeContentGen = .text
    }
    
    func setTypeContentEmail(){
        self.typeContentGen = .email
    }
    
    func setTypeContentContact(){
        self.typeContentGen = .contact
    }
    
    func setTypeContentLocation(){
        self.typeContentGen = .location
    }
    
    func setTypeContentEvent(){
        self.typeContentGen = .event
    }
    
    func setTypeContentSMS(){
        self.typeContentGen = .sms
    }
    
    func setTypeContentWifi(){
        self.typeContentGen = .wifi
    }
    
    func setTypeContentPhoneNumber(){
        self.typeContentGen = .phoneNumber
    }
    
    func setTypeContentWebsite(){
        self.typeContentGen = .website
    }
    
    func setTypeContentUrl(){
        self.typeContentGen = .url
    }
    
    func setContentGenerate(content: String){
        self.contentGenerate = content
    }
    
    func setContentGenerateEmail(email: Email){
        self.contentGenerateEmail = email
    }
    
    func setContentGenerateSMS(sms: SMS){
        self.contentGenerateSMS = sms
    }
    
    func setContentGenerateContact(contact: Contact){
        self.contentGenerateContact = contact
    }
    
    func setContentGenerateEvent(event: Event){
        self.contentGenerateEvent = event
    }
    
    func setContentGenerateLocation(location: Location){
        self.contentGenerateLocation = location
    }
    
    func setContentGenerateWifi(wifi: Wifi){
        self.contentGenerateWifi = wifi
    }
    
    func saveNewScanResult(scan: Scan){
        if self.historyScan.contains(where: { $0.content == scan.content }) == false {
            self.historyScan.append(scan)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "EntityScan", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(scan.content, forKey: "content")
        newUser.setValue(scan.type, forKey: "type")
        newUser.setValue(scan.id, forKey: "id")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    
    
    func displayToastMessage(_ message : String) -> Void {
        
        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
        toastView.layer.cornerRadius = 25
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let window = UIApplication.shared.delegate?.window!
        window?.addSubview(toastView)
        
        let horizontalCenterContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
        
        let widthContraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
        
        let verticalContraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[loginView(==50)]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["loginView": toastView])
        
        NSLayoutConstraint.activate([horizontalCenterContraint, widthContraint])
        NSLayoutConstraint.activate(verticalContraint)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return convert(output)
            }
        }
        return nil
    }
    
    func convert(_ cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//    func showAlert(content: String, title1: String, title2: String){
//        let alert = UIAlertController(title: content, message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: title1, style: .default, handler: { action in
//            
//        }))
//        alert.addAction(UIAlertAction(title: title2, style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
    
}
