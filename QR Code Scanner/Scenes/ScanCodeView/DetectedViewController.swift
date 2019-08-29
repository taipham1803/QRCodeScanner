//
//  DetectedViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/20/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class DetectedViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var lblTypeCode: UILabel!
    @IBOutlet weak var lblContentCode: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    
    var actions: [ScanManager.Action] = []
    
    @IBOutlet var btnActions: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scanCode()
        setupContainerView()
//        setupFunctionBtnActions()
    }
    
    func scanCode(){
        let result = ScanManager.shared.scan(originText: ScanManager.shared.originText)
        actions = result.action
        for index in (0..<btnActions.count).reversed() {
            btnActions[index].tag = index
            btnActions[index].setImage(actions[index].icon, for: .normal)
            btnActions[index].imageView?.contentMode = .scaleAspectFit
            btnActions[index].addTarget(self, action: #selector(btnActionsTaped(sender:)), for: .touchUpInside)
        }
        lblContentCode.text = ScanManager.shared.originText
        lblTypeCode.text = ScanManager.shared.typeContentScan
        let newScan = Scan.init(id: ScanManager.shared.historyScan.count, content: ScanManager.shared.originText, type: ScanManager.shared.typeContentScan)
        ScanManager.shared.saveNewScanResult(scan: newScan)
    }
    
    private func setupFunctionBtnActions(){
//        for index in 0..<btnActions.count{
//            btnActions[index].tag = index
//            btnActions[index].imageView?.contentMode = .scaleAspectFit
//            btnActions[index].addTarget(self, action: #selector(btnActionsTaped(sender:)), for: .touchUpInside)
//        }
        
        for index in (0..<btnActions.count).reversed() {
            btnActions[index].tag = index
            btnActions[index].imageView?.contentMode = .scaleAspectFit
            btnActions[index].addTarget(self, action: #selector(btnActionsTaped(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func btnActionsTaped(sender: UIButton) {

        switch sender.tag {
        case 0:
            actions[sender.tag].action()
            print(sender.tag)
            print("case 0")
        case 1:
            actions[sender.tag].action()
            print(sender.tag)
            print("case 1")
        case 2:
            actions[sender.tag].action()
            print(sender.tag)
            print("case 2")
        case 3:
            actions[sender.tag].action()
            print(sender.tag)
            print("case 3")
        default:
            print(-1)
        }
    }
    
    func setupContainerView(){
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 20
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
