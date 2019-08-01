//
//  GenerateCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldInput: UITextField!
    @IBOutlet weak var imgViewQRCode: UIImageView!
    var stringInput:String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldInput.delegate = self
        
//        view.backgroundColor = UIColor.orange
        
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
