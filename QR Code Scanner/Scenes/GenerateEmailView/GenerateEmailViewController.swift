//
//  GenerateEmailViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateEmailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var textFieldYourEmail: UITextField!
    @IBOutlet weak var textFieldSubject: UITextField!
    @IBOutlet weak var textViewContent: UITextView!
    var yourEmail: String = ""
    var subject: String = ""
    var message: String = ""
    
    @IBAction func btnGenerate(_ sender: Any) {
        saveEmail()
        self.performSegue(withIdentifier: "segueEmailToQRcode", sender: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }
    
    func setupDelegate(){
        textFieldYourEmail.delegate = self
        textFieldSubject.delegate = self
        textViewContent.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == textFieldYourEmail){
            yourEmail = textField.text!
        } else if (textField == textFieldSubject){
            subject = textField.text!
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == textViewContent){
            message = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        message = textView.text!
    }
    
    func saveEmail(){
        ScanManager.shared.setContentGenerateEmail(email: Email.init(yourEmail: yourEmail, subject: subject, message: message))
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        ScanManager.shared.setContentGenerate(content: textField.text ?? "")
//    }
    
    func showAlert(content: String, title1: String, title2: String){
        let alert = UIAlertController(title: content, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title1, style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: title2, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}
