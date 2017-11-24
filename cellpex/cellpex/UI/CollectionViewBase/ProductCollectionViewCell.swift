//
//  ProductCollectionViewCell.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/28/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDateLabel: UILabel!
    @IBOutlet weak var productSatusLabel: UILabel!
    @IBOutlet weak var productPropertiesLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
     var userTapAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.userLabelTap))
        userLabel.addGestureRecognizer(gesture)
    }
    
    @objc func userLabelTap() {
        self.userTapAction?()
    }
    
}
