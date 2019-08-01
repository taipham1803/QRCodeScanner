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
    let historyCellID = "HistoryTableViewCell"
    
    let arrayResultScan:[ResultScan] = [
        ResultScan(typeId: 1, name: "Phone Number", content: "0869898203"),
        ResultScan(typeId: 2, name: "Web", content: "https://emddi.com"),
        ResultScan(typeId: 3, name: "Gmail", content: "taipham1803@gmail.com"),
        ResultScan(typeId: 4, name: "Youtube", content: "https://www.youtube.com/watch?v=TMsuP-QCEro"),
        ResultScan(typeId: 5, name: "Facebook", content: "https://www.facebook.com/cu0ngkimgiang")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        tableViewHistory.register(UINib.init(nibName: historyCellID, bundle: nil), forCellReuseIdentifier: historyCellID)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResultScan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCellID) as? HistoryTableViewCell
        cell?.lblTitle.text = arrayResultScan[indexPath.row].name
        cell?.layer.cornerRadius = 25
        cell?.backgroundColor = .white
        return cell ?? UITableViewCell()
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
