//
//  HistoryTableViewCell.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/1/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewCustom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    
    func setupUI() {
        
        self.viewCustom.layer.cornerRadius = 14
        self.viewCustom.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 7
//        self.viewCustom.layer.shadowColor = UIColor.gray.cgColor
//        self.viewCustom.layer.shadowPath = UIBezierPath.init(roundedRect: self.viewCustom.bounds, cornerRadius: 10).cgPath
//        self.viewCustom.backgroundColor = .white
//        self.viewCustom.layer.cornerRadius = 12
//        self.viewCustom.layer.shadowOpacity = 0.6
//        self.viewCustom.layer.shadowRadius = 0.5
//        imgImage.layer.cornerRadius = 12
    }
    
}
