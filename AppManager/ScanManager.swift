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

class ScanManager {
    
    static let shared = ScanManager()
    
    private init() {}
    
    var status: Status = .scan
    fileprivate(set) var typeContent: TypeContent = .text
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
    }
    
    func setTypeContentText(){
        self.typeContent = .text
    }
    
    func setTypeContentEmail(){
        self.typeContent = .email
    }
    
    func setTypeContentContact(){
        self.typeContent = .contact
    }
    
    func setTypeContentLocation(){
        self.typeContent = .location
    }
    
    func setTypeContentEvent(){
        self.typeContent = .event
    }
    
    func setTypeContentSMS(){
        self.typeContent = .sms
    }
    
    func setTypeContentWifi(){
        self.typeContent = .wifi
    }
    
    func setTypeContentPhoneNumber(){
        self.typeContent = .phoneNumber
    }
    
    func setTypeContentWebsite(){
        self.typeContent = .website
    }
    
    func setTypeContentUrl(){
        self.typeContent = .url
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
//        self.historyScan.append(scan)
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
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
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
