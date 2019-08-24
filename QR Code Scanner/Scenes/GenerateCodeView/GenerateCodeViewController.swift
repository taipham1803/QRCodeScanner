//
//  GenerateCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateCodeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionTableGenerate: UICollectionView!

    var stringInput:String = ""
    let GenerateCollectionViewCell = "GenerateCollectionViewCell"
    
    let arrayGenerateType:[Scan] = [
        Scan(id: 1, content: "Website", type: "website"),
        Scan(id: 2, content: "Contact", type: "contact"),
        Scan(id: 3, content: "Plain text", type: "text"),
        Scan(id: 4, content: "Phone number", type: "phoneNumber"),
        Scan(id: 5, content: "Email", type: "email"),
        Scan(id: 6, content: "Link URL", type: "url"),
        Scan(id: 7, content: "Location", type: "location"),
        Scan(id: 8, content: "Event information", type: "event"),
        Scan(id: 9, content: "SMS", type: "sms"),
        Scan(id: 10, content: "Wifi", type: "wifi")
    ]
    
    
    @IBAction func btnSaveQRCode(_ sender: Any) {
        if(stringInput != ""){
//            saveImage(imgViewQRCode.image!)
            if let imageQR = UIImage(named: "qrcode") {
                if let data = UIImageJPEGRepresentation(imageQR, 0.75) {
                    let filename = getDocumentsDirectory().appendingPathComponent("copy.jpg")
                    try? data.write(to: filename)
                }
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1.0)
        setupCollectionView()
    }
    
    func setupCollectionView(){
        collectionTableGenerate.dataSource = self
        collectionTableGenerate.delegate = self
        collectionTableGenerate.backgroundColor = UIColor(white: 1, alpha: 0)
        collectionTableGenerate.register(UINib.init(nibName: GenerateCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: GenerateCollectionViewCell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGenerateType.count
//        return MasterDataManager.shared.arrayGenerateType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenerateCollectionViewCell, for: indexPath) as? GenerateCollectionViewCell
        cell?.lblCellName.text = arrayGenerateType[indexPath.row].content
        cell?.imgViewGenerate.image = UIImage(named: "qrcode")
        cell?.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCollectionView = collectionView.frame.size.width
        return CGSize(width: (widthCollectionView - 10)/2, height: 220)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(arrayGenerateType[indexPath.row].type == "text"){
            let text = ""
//            ScanManager.shared.setTypeContentText(string: text)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToText.rawValue, sender: 1)
        } else if (arrayGenerateType[indexPath.row].type == "url"){
            let url = "apple.com"
//            ScanManager.shared.setTypeContentUrl(string: url)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToText.rawValue, sender: 1)
        } else if (arrayGenerateType[indexPath.row].type == "website"){
            let website = "tinhte.vn"
//            ScanManager.shared.setTypeContentWebsite(string: website)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToText.rawValue, sender: 1)
        } else if (arrayGenerateType[indexPath.row].type == "phoneNumber"){
            let phonenumber = "0869898203"
//            ScanManager.shared.setTypeContentPhoneNumber(string: phonenumber)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToText.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "email"){
            let email = Email.init(yourEmail: "taipham@gmail.com", subject: "Abc", message: "Hello cac ban!")
//            ScanManager.shared.setTypeContentEmail(email: email)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToMail.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "location"){
            let location = Location.init(yourAddress: "Hanoi", latitude: "127.111", longitude: "5.0001")
//            ScanManager.shared.setTypeContentLocation(location: location)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToLocation.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "contact"){
            let contact = Contact.init(firstName: "a", lastName: "b", company: "emddi", phoneNumber: "12345678", note: "hihi")
//            ScanManager.shared.setTypeContentContact(contact: contact)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToContact.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "sms"){
            let sms = SMS.init(yourPhone: "12345678", message: "abcd")
//            ScanManager.shared.setTypeContentSMS(sms: sms)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToSMS.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "wifi"){
            let wifi = Wifi.init(name: "abc", password: "abc", encryption: "WPA2")
//            ScanManager.shared.setTypeContentWifi(wifi: wifi)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToWifi.rawValue, sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "event"){
            let event = Event.init(eventTitle: "title event", eventLocation: "event'location", startTime: Date(), endTime: Date())
//            ScanManager.shared.setTypeContentEvent(event: event)
            self.performSegue(withIdentifier: ConstantManager.Segue.segueGenerateToEvent.rawValue, sender: 1)
        }
    }
    

    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if(textField == textFieldInput){
//            stringInput = textFieldInput.text ?? ""
//        }
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        textFieldInput.resignFirstResponder()
//        return true
//    }
    
    @IBAction func backToGenerateViewController(segue:UIStoryboardSegue){
        print("press cancel to back Generate view")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueGenerateToText":
            print("destination : ", segue.destination)
            if let vc = segue.destination as? GenerateTextViewController {

            }
        default:
            break
        }
    }

}
