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
        guard let image = imgViewQRCode.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        shareImagePro(img: ScanManager.shared.generateQRCode(from: contentToGenerate)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateQRCode()
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
            contentToGenerate = "sms:\(sms.yourPhone)&body=\(sms.message)"
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func shareImagePro(img: UIImage) {
        let messageStr = "qrcode"
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [img, messageStr], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareContent(text: String){
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}


