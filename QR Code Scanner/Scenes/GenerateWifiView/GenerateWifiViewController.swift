//
//  GenerateWifiViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateWifiViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldWifiName: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEncry: UITextField!
    var name: String = ""
    var password: String = ""
    var encryption: String = ""
    
    @IBAction func btnGenerate(_ sender: Any) {
        saveWifi()
        self.performSegue(withIdentifier: "segueWifiToQRcode", sender: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        // Do any additional setup after loading the view.
    }
    
    func setupDelegate(){
        textFieldWifiName.delegate = self
        textFieldPassword.delegate = self
        textFieldEncry.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == textFieldWifiName){
            name = textField.text!
        } else if (textField == textFieldPassword){
            password = textField.text!
        }  else if (textField == textFieldEncry){
            encryption = textField.text!
        }
        return true
    }
    
    func saveWifi(){
        ScanManager.shared.setContentGenerateWifi(wifi: Wifi.init(name: name, password: password, encryption: encryption))
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
