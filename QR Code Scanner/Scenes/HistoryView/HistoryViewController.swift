//
//  HistoryViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/20/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblNoHistory: UILabel!
    @IBOutlet weak var tableViewHistory: UITableView!
    
    let pasteboard = UIPasteboard.general
    let historyCellID = "HistoryTableViewCell"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [EntityScan] = []
    
    let arrayResultScan:[Scan] = ScanManager.shared.historyScan
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 255/255, green: 242/255, blue: 242/255, alpha: 1.0)
        tableViewHistory.delegate = self
        tableViewHistory.dataSource = self
        tableViewHistory.register(UINib.init(nibName: historyCellID, bundle: nil), forCellReuseIdentifier: historyCellID)
        tableViewHistory.backgroundColor = UIColor(white: 1, alpha: 0)
        view.addSubview(tableViewHistory)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.tableViewHistory.reloadData()
        if(ScanManager.shared.historyScan.count>0){
            print("Check count array history: ", ScanManager.shared.historyScan.count)
            lblNoHistory.text = ""
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ScanManager.shared.historyScan.count
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: historyCellID) as? HistoryTableViewCell
//        cell?.lblTitle.text = ScanManager.shared.historyScan[indexPath.row].type
//        cell?.lblBody.text = ScanManager.shared.historyScan[indexPath.row].content
        
        cell?.lblTitle.text = items.reversed()[indexPath.row].type
        cell?.lblBody.text = items.reversed()[indexPath.row].content
//        cell?.layer.cornerRadius = 25
        cell?.backgroundColor = UIColor(white: 1, alpha: 0)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let item = self.items[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("Share")
            self.shareContent(text: self.items[indexPath.row].content!)
        }
        
        return [delete,share]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tap on tableView in ", indexPath.row)
        showActionSheetButtonTapped(index: indexPath.row)
    }
    
    func fetchData() {
        
        do {
            items = try context.fetch(EntityScan.fetchRequest())
            print(items)
            DispatchQueue.main.async {
                self.tableViewHistory.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    func shareContent(text: String){
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showActionSheetButtonTapped(index: Int){
        let myActionSheet = UIAlertController(title: "Color", message: "What do you want?", preferredStyle: UIAlertController.Style.actionSheet)
        
        // blue action button
        let blueAction = UIAlertAction(title: "Open on Safari", style: UIAlertAction.Style.default) { (action) in
            print("Open on Safari button tapped")
            guard let url = URL(string: self.items[index].content!) else { return }
            UIApplication.shared.open(url)
        }
        
        // red action button
        let redAction = UIAlertAction(title: "Copy to clipboard", style: UIAlertAction.Style.default) { (action) in
            print("Copy to clipboard button tapped")
            ScanManager.shared.displayToastMessage("Copied to clipboard")
            self.pasteboard.string = self.items[index].content!
        }
        
        // yellow action button
        let yellowAction = UIAlertAction(title: "Share", style: UIAlertAction.Style.default) { (action) in
            print("Share button tapped")
            self.shareContent(text: self.items[index].content!)
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            print("Cancel action button tapped")
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(blueAction)
        myActionSheet.addAction(redAction)
        myActionSheet.addAction(yellowAction)
        myActionSheet.addAction(cancelAction)
        
        // present the action sheet
        DispatchQueue.main.async {
            self.present(myActionSheet, animated: true, completion: nil)
        }
    }

}
