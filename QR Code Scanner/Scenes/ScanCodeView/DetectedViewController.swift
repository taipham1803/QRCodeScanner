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
        setupFunctionBtnActions()
    }
    
    func scanCode(){
        let result = ScanManager.shared.scan(originText: ScanManager.shared.originText)
        let actions = result.action
        for i in 0..<btnActions.count {
            btnActions[i].tag = i
            btnActions[i].setImage(actions[i].icon, for: .normal)
        }
        lblContentCode.text = ScanManager.shared.originText
        lblTypeCode.text = ScanManager.shared.typeContentScan
    }
    
    private func setupFunctionBtnActions(){
        for index in 0..<btnActions.count{
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
        case 1:
            actions[sender.tag].action()
            print(sender.tag)
        case 2:
            actions[sender.tag].action()
            print(sender.tag)
        case 3:
            actions[sender.tag].action()
            print(sender.tag)
        default:
            print(-1)
        }
    }
    
    func setupContainerView(){
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
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
