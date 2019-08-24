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

class ScanManager {
    
    static let shared = ScanManager()
    
    var originText = ""
    var detectedObject: Any?
    var typeContentScan = ""
    
    private init() {
        self.originText = ""
        self.detectedObject = ""
        self.typeContent = TypeContent.text("")
    }
    
    var status: Status = .scan
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
        
        var action: [Action] {
            switch self {
            case .text(let str):
                return [.copy(str), .safari(str), .chrome(str), .share(str)]
            case .email(let email):
                return [.copy(email.message), .safari(email.message), .openMail(email), .share(email.message)]
            case .contact(let str):
                return [.copy(str.phoneNumber), .safari(str.phoneNumber), .chrome(str.phoneNumber), .share(str.phoneNumber)]
            case .event(let event):
                return [.copy(event.eventTitle), .safari(event.eventTitle), .chrome(event.eventTitle), .share(event.eventTitle)]
            case .location(let location):
                return [.copy(location.yourAddress), .safari(location.yourAddress), .chrome(location.yourAddress),  .share(location.yourAddress)]
            case .phoneNumber(let phone):
                return [.copy(phone), .safari(phone), .chrome(phone), .share(phone)]
            case .sms(let sms):
                return [.copy(sms.message), .safari(sms.message), .chrome(sms.message), .share(sms.message)]
            case .url(let url):
                return [.copy(url), .safari(url), .chrome(url), .share(url)]
            case .website(let website):
                return [.copy(website), .safari(website), .chrome(website), .share(website)]
            case .wifi(let wifi):
                return [.copy(wifi.name), .safari(wifi.name), .chrome(wifi.name), .share(wifi.name)]
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
        case openMail(Email)
        case message(SMS)
        case callPhone(String)
        
        var icon: UIImage? {
            switch self {
            case .copy:
                return UIImage.init(named: "copy")
            default:
                return UIImage.init(named: "copy")
            }
        }
        
        func action() {
            switch self {
            case .copy(let str):
                let pasteboard = UIPasteboard.general
//                    ScanManager.displayToastMessage("Copied to clipboard")
                pasteboard.string = str as? String
                break
            case .share(let string):
                let text = string
                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = ScanCodeViewController().view
                activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
                ScanCodeViewController().present(activityViewController, animated: true, completion: nil)
            case .safari(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .chrome(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .youtube(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .facebook(let str):
                guard let url = URL(string: str) else { return }
                UIApplication.shared.open(url)
            case .openWifi(let wifi):
                print("Connecting to Wifi ",wifi.name, wifi.password )
            case .openMail(let email):
                print("Open email ", email.yourEmail)
            case .message(let message):
                print("Open message ", message.yourPhone)
            case .callPhone(let phone):
                print("Open phone ", phone)
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
    
    public func scan(originText: String) -> TypeContent {
        let contentUse = originText.lowercased()
        if(contentUse.prefix(6).contains("tel:")){
            typeContentScan = "Phone Number"
            
        }else if(contentUse.prefix(6).contains("wifi")){
            typeContentScan = "WIFI"
        } else if(contentUse.prefix(6).contains("smsto:")){
            typeContentScan = "SMS"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.mailRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "Email"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.youtubeRegex.rawValue, in: contentUse).count>0){
            typeContentScan = "Youtube"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.facebookRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "Facebook"
        } else if(contentUse.prefix(40).contains("instagram")){
            typeContentScan = "Instagram"
        } else if(contentUse.prefix(40).contains("maps.google.com") || contentUse.prefix(40).contains("www.google.com/maps")){
            typeContentScan = "Google Map"
            let location = Location.init(yourAddress: "Location", latitude: "21.02375615517149", longitude: "105.8426985435633")
            return .location(location)
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.urlRegEx.rawValue, in: contentUse).count>0){
            typeContentScan = "URL"
            return .text(contentUse)
        } else {
            typeContentScan = "Text"
            return .text(contentUse)
        }
        return .text("aString")
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
    
    func setTypeContentText(string: String){
        self.typeContent = .text(string)
        
    }
    
    func setTypeContentEmail(email: Email){
        self.typeContent = .email(email)
    }
    
    func setTypeContentContact(contact: Contact){
        self.typeContent = .contact(contact)
    }
    
    func setTypeContentLocation(location: Location){
        self.typeContent = .location(location)
    }
    
    func setTypeContentEvent(event: Event){
        self.typeContent = .event(event)
    }
    
    func setTypeContentSMS(sms: SMS){
        self.typeContent = .sms(sms)
    }
    
    func setTypeContentWifi(wifi: Wifi){
        self.typeContent = .wifi(wifi)
    }
    
    func setTypeContentPhoneNumber(string: String){
        self.typeContent = .phoneNumber(string)
    }
    
    func setTypeContentWebsite(string: String){
        self.typeContent = .website(string)
    }
    
    func setTypeContentUrl(string: String){
        self.typeContent = .url(string)
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
    
    
    
    func displayToastMessage(_ message : String) {
        
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
    
//    func showAlert(content: String, title1: String, title2: String){
//        let alert = UIAlertController(title: content, message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: title1, style: .default, handler: { action in
//            
//        }))
//        alert.addAction(UIAlertAction(title: title2, style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
    
}
