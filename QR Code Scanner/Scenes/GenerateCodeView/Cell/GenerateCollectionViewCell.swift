//
//  GenerateCollectionViewCell.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/5/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class GenerateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCellName: UILabel!
    @IBOutlet weak var lblMainViewCell: UIView!
    @IBOutlet weak var imgViewGenerate: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    
    func setupUI() {
        self.lblMainViewCell.layer.cornerRadius = 14
        self.lblMainViewCell.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 7
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 10).cgPath
//        self.layer.cornerRadius = 12
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 5
    }
    
}
