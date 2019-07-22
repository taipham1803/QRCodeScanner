//
//  HistoryViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/20/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCity")
//        cell?.textLabel?.text = arrayCity[indexPath.row].enName
//        return cell!
        return UITableViewCell()
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
