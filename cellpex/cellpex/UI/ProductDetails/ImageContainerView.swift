//
//  ImageContainerView.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/23/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class ImageContainerView: UIView {

    @IBOutlet weak var postImage: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }
    
    func nibName() -> String? {
        return "\(type(of: self))"
    }
    
    fileprivate func sharedInitialization() {
        if let nibName = nibName() {
            let containerView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)![0] as! UIView
            containerView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(containerView)
            let views = ["container":containerView]
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: views)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: views)
            
            self.addConstraints(horizontalConstraints)
            self.addConstraints(verticalConstraints)
        }
    }
}
