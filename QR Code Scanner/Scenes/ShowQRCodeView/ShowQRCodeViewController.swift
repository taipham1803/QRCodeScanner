//
//  ShowQRCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/16/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

class ShowQRCodeViewController: UIViewController {
    @IBOutlet weak var imgViewQRCode: UIImageView!
    @IBOutlet weak var lblQRCodeType: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    @IBOutlet weak var imgCheckQR: UIImageView!
    
    var contentToGenerate: String = ""
    var imgQR = UIImage()
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: Any){
        if (saveImage(image: imgQR)){
            print("Save image success!")
        } else {
            print("Save image fail!")
        }
        imgCheckQR.image = imgQR
        if let message = storeImageToDocumentDirectory(image: imgQR, fileName: "QRCode"){
            print(message)
        }
    }
    
    @IBAction func btnShare(_ sender: Any) {
//        shareContent(text: contentToGenerate)
        shareImage(image: ScanManager.shared.generateQRCode(from: contentToGenerate)!)
//        shareImagePro()
        
//        let img: UIImage = imgQR
//        let shareItems:Array = [img]
//        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
//        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
//        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareImagePro() {
        let img = UIImage(named: "qrcode")
        let messageStr = "qrcode"
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [img!, messageStr], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareImage(image: UIImage){
        let imageShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
    }
    
    public static var documentsDirectoryURL: URL {
        return FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
    }
    public static func fileURLInDocumentDirectory(_ fileName: String) -> URL {
        return self.documentsDirectoryURL.appendingPathComponent(fileName)
    }
    
    func storeImageToDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        print("Run storeImageToDocumentDirectory")
        guard let data = UIImageJPEGRepresentation(image, 0.5) else {
            print("data nil")
            return nil
        }
        let fileURL = ShowQRCodeViewController.fileURLInDocumentDirectory(fileName)
        do {
            try data.write(to: fileURL)
            print("data fileURL")
            return fileURL
        } catch {
            print("data catch")
            return nil
        }
    }
    
    func generateQRCode(){
        switch ScanManager.shared.typeContent {
        case .text:
            if let text = ScanManager.shared.contentGenerate{
                contentToGenerate = text
                lblQRCodeType.text = "QR Code Text"
            }
        case .email:
            if let email = ScanManager.shared.contentGenerateEmail{
                contentToGenerate = "mailto:" + email.yourEmail + "?subject=" + email.subject + "&body=" + email.message
                lblQRCodeType.text = "QR Code Email"
            }
        case .contact:
            if let contact = ScanManager.shared.contentGenerateContact{
                contentToGenerate = "firstname:" + contact.firstName + "&lastname:" + contact.lastName + "&company=" + contact.company + "&phoneNumber=" + contact.phoneNumber + "&note=" + contact.note
                lblQRCodeType.text = "QR Code Contact"
            }
        case .event:
            guard let event = ScanManager.shared.contentGenerateEvent else {
                return
            }
            contentToGenerate = "Event Title:" + event.eventTitle + "&Event Location:" + event.eventLocation + "&Starttime:" + event.startTime.asString(style: .short) + "$Endtime" + event.endTime.asString(style: .short)
            lblQRCodeType.text = "QR Code Event"
        case .location:
            guard let location = ScanManager.shared.contentGenerateLocation else {
                return
            }
            contentToGenerate = "https://maps.google.com/local?q=" + location.latitude + "," + location.longitude
            lblQRCodeType.text = "QR Code Location"
        case .sms:
            guard let sms = ScanManager.shared.contentGenerateSMS else {
                return
            }
            contentToGenerate = "SMSTO:" + sms.yourPhone + ":" + sms.message
            lblQRCodeType.text = "QR Code SMS"
        case .wifi:
            guard let wifi = ScanManager.shared.contentGenerateWifi else {
                return
            }
            contentToGenerate = "WIFI:S:" + wifi.name + ";T=" + wifi.encryption + ";P:" + wifi.password
            lblQRCodeType.text = "QR Code Wifi"
        case .phoneNumber:
            guard let phoneNumber = ScanManager.shared.contentGenerate else {
                return
            }
            contentToGenerate = phoneNumber
            lblQRCodeType.text = "QR Code Phone Number"
        case .website:
            guard let website = ScanManager.shared.contentGenerate else {
                return
            }
            contentToGenerate = website
            lblQRCodeType.text = "QR Code Website"
        case .url:
            guard let url = ScanManager.shared.contentGenerate else {
                return
            }
            contentToGenerate = url
            lblQRCodeType.text = "QR Code URL"
            
        }
        lblContent.text = "Content of QR Code: " + contentToGenerate
        imgViewQRCode.image = ScanManager.shared.generateQRCode(from: contentToGenerate)
        imgQR = ScanManager.shared.generateQRCode(from: contentToGenerate)!
    }
    
    func shareContent(text: String){
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}


