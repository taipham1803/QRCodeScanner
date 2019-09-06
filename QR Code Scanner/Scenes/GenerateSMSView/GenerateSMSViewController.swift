//
//  GenerateSMSViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateSMSViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var btnGenerate: UIButton!
    
    var yourPhone: String = ""
    var message: String = ""
    
    @IBAction func btnGenerate(_ sender: Any) {
        saveSMS()
        self.performSegue(withIdentifier: "segueSMSToQRcode", sender: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupButtonGenerate()
    }
    
    func setupButtonGenerate(){
        btnGenerate.backgroundColor = ScanManager.shared.hexStringToUIColor(hex: "#C7B8F5")
        btnGenerate.layer.cornerRadius = 14
        btnGenerate.layer.masksToBounds = true
        btnGenerate.setTitleColor(ScanManager.shared.hexStringToUIColor(hex: "#ffffff"), for: .normal)
    }
    
    func setupDelegate(){
        textFieldPhoneNumber.delegate = self
        textViewMessage.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        yourPhone = textField.text!
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == textViewMessage){
            message = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        message = textView.text!
    }
    
    func saveSMS(){
        ScanManager.shared.setContentGenerateSMS(sms: SMS.init(yourPhone: yourPhone, message: message))
    }
    
}
