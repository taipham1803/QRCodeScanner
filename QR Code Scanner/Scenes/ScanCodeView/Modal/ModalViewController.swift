//
//  ModalViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/29/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableViewOptionOpen: UITableView!
    
    let arrayOptionOpen = ["Open in Youtube", "Open in Safari", "Copy this link"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOptionOpen.delegate = self
        tableViewOptionOpen.dataSource = self
        self.view.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell") as? OptionTableViewCell
        cell?.lblNameCell.text = arrayOptionOpen[indexPath.row]
        return cell ?? UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionTableViewCell
//        cell.imgImage.image = UIImage(named: arrayDes[indexPath.row].image)
//        cell.lblTitle.text = arrayDes[indexPath.row].name
//        cell.lblDescription.text = arrayDes[indexPath.row].description
//        return cell
//    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
