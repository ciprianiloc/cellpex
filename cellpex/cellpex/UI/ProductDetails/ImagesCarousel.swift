//
//  ImagesCarousel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 22/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class ImagesCarousel: UIView {
    
    private var postImages = [UIImage]()
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    func addImages(images : [UIImage]) {
        postImages.append(contentsOf: images)
        self.loadImageCarousel()
    }
    
    private func loadImageCarousel(){
        var lastImageViewRight : NSLayoutXAxisAnchor?
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(postImages.count)), height: scrollView.frame.size.height)
        for image in postImages {
            let imageView = UIImageView.init(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
            if let previosImageRight = lastImageViewRight {
                imageView.leftAnchor.constraint(equalTo: previosImageRight)
            } else {
                imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
            }
            lastImageViewRight = imageView.rightAnchor
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if postImages.count > 0 {
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(postImages.count)), height: scrollView.frame.size.height)
        }

    }
    
}
