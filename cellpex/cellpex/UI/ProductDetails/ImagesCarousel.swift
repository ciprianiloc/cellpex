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
    var numberOfImages = 0
    var pageNumber = 0
    
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
        postImages.removeAll()
        postImages.append(contentsOf: images)
        self.loadImageCarousel()
    }
    
    private func loadImageCarousel(){
        var x: CGFloat = 0.0
        numberOfImages = 0
        for image in postImages {
            numberOfImages = numberOfImages + 1
            let containerView = ImageContainerView.init(frame: scrollView.frame)
            containerView.frame.origin.x = x
            x = x + containerView.frame.size.width
            scrollView.addSubview(containerView)
            containerView.postImage.image = image
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(numberOfImages)), height: scrollView.frame.size.height)
        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = pageNumber
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let pageWidth = self.frame.size.width
        scrollView.contentSize = CGSize(width: (pageWidth * CGFloat(numberOfImages)), height: scrollView.frame.size.height)
        var x : CGFloat = 0.0
        scrollView.setContentOffset(CGPoint(x: CGFloat(pageNumber) * pageWidth, y: 0.0), animated: false)

        for view in scrollView.subviews {
            view.frame.size.width = pageWidth
            view.frame.origin.x = x
            x = x + pageWidth
        }
    }
}

extension ImagesCarousel: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = self.frame.size.width
        pageNumber = Int((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0))
        pageControl.currentPage = pageNumber
    }
}
