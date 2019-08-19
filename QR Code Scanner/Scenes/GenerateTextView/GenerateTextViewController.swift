//
//  GenerateTextViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateTextViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var content:String = ""
    
    @IBAction func btnGenerate(_ sender: Any) {
        saveText()
        self.performSegue(withIdentifier: "segueTextToQRcode", sender: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        content = textField.text!
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        content = textField.text!
    }
    
    func saveText(){
        ScanManager.shared.setTypeContentText()
        ScanManager.shared.setContentGenerate(content: content)
    }
    
    
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
////                let height = self.view.frame.height
////                self.view.frame.size.height = height - keyboardSize.height
//                self.view.frame.origin.y -= keyboardSize.height
//                self.btnGenerate.layoutIfNeeded()
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    

}
