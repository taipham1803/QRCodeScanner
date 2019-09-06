//
//  GenerateEventViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/20/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateEventViewController: UIViewController {

    @IBOutlet weak var textFieldEventTitle: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldStarttime: UITextField!
    @IBOutlet weak var textFieldEndtime: UITextField!
    @IBOutlet weak var btnGenerate: UIButton!
    
    @IBAction func btnGenerate(_ sender: Any) {
        self.performSegue(withIdentifier: "segueEventToQRcode", sender: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonGenerate()
    }
    
    func setupButtonGenerate(){
        btnGenerate.backgroundColor = ScanManager.shared.hexStringToUIColor(hex: "#C7B8F5")
        btnGenerate.layer.cornerRadius = 14
        btnGenerate.layer.masksToBounds = true
        btnGenerate.setTitleColor(ScanManager.shared.hexStringToUIColor(hex: "#ffffff"), for: .normal)
    }
    



}
