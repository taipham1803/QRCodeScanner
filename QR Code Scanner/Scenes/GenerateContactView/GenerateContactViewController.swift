//
//  GenerateContactViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateContactViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldCompany: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textViewNote: UITextView!
    var firstName: String = ""
    var lastName: String = ""
    var company: String = ""
    var phoneNumber: String = ""
    var note: String = ""
    
    @IBAction func btnGenerate(_ sender: Any) {
        saveContact()
        self.performSegue(withIdentifier: "segueContactToQRcode", sender: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
    }

    func setupDelegate(){
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldCompany.delegate = self
        textFieldPhoneNumber.delegate = self
        textViewNote.delegate = self
    }
    
    func saveContact(){
        ScanManager.shared.setContentGenerateContact(contact: Contact.init(firstName: firstName, lastName: lastName, company: company, phoneNumber: phoneNumber, note: note))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == textFieldFirstName){
            firstName = textField.text!
        } else if (textField == textFieldLastName){
            lastName = textField.text!
        }  else if (textField == textFieldCompany){
            company = textField.text!
        }  else if (textField == textFieldPhoneNumber){
            phoneNumber = textField.text!
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
        if(textView == textViewNote){
            note = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        note = textView.text!
    }

}
