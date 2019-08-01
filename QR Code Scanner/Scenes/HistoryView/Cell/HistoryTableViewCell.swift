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
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowPath = UIBezierPath.init(roundedRect: self.containerView.bounds, cornerRadius: 10).cgPath
        self.containerView.backgroundColor = .white
//        self.containerView.layer.cornerRadius = 12
        self.containerView.layer.shadowOpacity = 0.9
        self.containerView.layer.shadowRadius = 5
//        imgImage.layer.cornerRadius = 12
    }
    
}
