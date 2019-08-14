//
//  GenerateCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateCodeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var collectionTableGenerate: UICollectionView!
    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var imgViewQRCode: UIImageView!
    var stringInput:String = ""
    let GenerateCollectionViewCell = "GenerateCollectionViewCell"
    
    let arrayFunctionCell:[String] = [
        "Website",
        "Contact",
        "Plain text",
        "Phone number",
        "Email",
        "Link URL",
        "Location",
        "Event information"
    ]
    
    let arrayGenerateType:[Scan] = [
        Scan(id: 1, content: "Website", type: "text"),
        Scan(id: 2, content: "Contact", type: "contact"),
        Scan(id: 3, content: "Plain text", type: "text"),
        Scan(id: 4, content: "Phone number", type: "text"),
        Scan(id: 5, content: "Email", type: "email"),
        Scan(id: 6, content: "Link URL", type: "text"),
        Scan(id: 7, content: "Location", type: "location"),
        Scan(id: 8, content: "Event information", type: "event"),
        Scan(id: 9, content: "SMS", type: "sms"),
        Scan(id: 10, content: "Wifi", type: "wifi")
    ]
    
    
    @IBAction func btnGenerateCode(_ sender: Any) {
        textFieldInput.resignFirstResponder()
        if(stringInput != ""){
            imgViewQRCode.image = generateQRCode(from: stringInput)
        }
    }
    
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
    
    @IBAction func btnShareQRCode(_ sender: Any) {
        
    }
    
//    func validateName(name: String) -> Bool{
//        if(name.count>3){
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func validateEmail(email: String) -> Bool{
//        if(email.count>6){
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func validatePhone(phone: String) -> Bool{
//        if(phone.count>6){
//            return true
//        } else {
//            return false
//        }
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1.0)

        textFieldInput.delegate = self
        collectionTableGenerate.dataSource = self
        collectionTableGenerate.delegate = self
        collectionTableGenerate.backgroundColor = UIColor(white: 1, alpha: 0)
        
        
//        collectionTableGenerate.minimumInteritemSpacing = 0
//        collectionTableGenerate.minimumLineSpacing = 0
        collectionTableGenerate.register(UINib.init(nibName: GenerateCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: GenerateCollectionViewCell)
//        view.backgroundColor = UIColor.orange
//        tabBarController?.tabBar.
//        UITabBar.appearance().layer.borderWidth = 0.0
//        UITabBar.appearance().clipsToBounds = true
//        self.tabBarItem.setValue(true, forKey: "_hidesShadow")
//        self.tabBarItem.setValue(true, forKey: "_hidesShadow")
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let numberOfItemsPerRow:CGFloat = 4
//        let spacingBetweenCells:CGFloat = 16
//
//        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
//
//        if let collection = self.collectionView{
//            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//            return CGSize(width: width, height: width)
//        }else{
//            return CGSize(width: 0, height: 0)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayGenerateType.count
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
//        let heightCollectionView = collectionView.frame.size.height
        
        return CGSize(width: (widthCollectionView - 10)/2, height: 220)
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(arrayGenerateType[indexPath.row].type == "text"){
            self.performSegue(withIdentifier: "segueGenerateToText", sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "email"){
            self.performSegue(withIdentifier: "segueGenerateToMail", sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "location"){
            self.performSegue(withIdentifier: "segueGenerateToLocation", sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "contact"){
            self.performSegue(withIdentifier: "segueGenerateToContact", sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "sms"){
            self.performSegue(withIdentifier: "segueGenerateToSMS", sender: 1)
        } else if(arrayGenerateType[indexPath.row].type == "wifi"){
            self.performSegue(withIdentifier: "segueGenerateToWifi", sender: 1)
        } 
        
    }
    
//    func saveImage(image: UIImage) -> Bool {
//        guard let data = UIImageJPEGRepresentation(image, 1) ?? UIImagePNGRepresentation(image) else {
//            return false
//        }
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            return false
//        }
//        do {
//            try data.write(to: directory.appendingPathComponent("fileName.png")!)
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == textFieldInput){
            stringInput = textFieldInput.text ?? ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textFieldInput.resignFirstResponder()
        return true
    }
    
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
