//
//  ImagesCarousel.swift
//  cellpex
//
//  Created by Ciprian Iloc on 22/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class ImagesCarousel: UIView {
    
    private var postImagesURL = [String?]()
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var numberOfImages = 0
    
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
    
    func addImagesURL(imagesURL : [String?]) {
        postImagesURL.removeAll()
        postImagesURL.append(contentsOf: imagesURL)
        self.loadImageCarousel()
    }
    
    private func loadImageCarousel(){
        var x: CGFloat = 0.0
        numberOfImages = 0
        for imageURL in postImagesURL {
            if let imageURLString = imageURL {
                numberOfImages = numberOfImages + 1
                let containerView = ImageContainerView.init(frame: scrollView.frame)
                containerView.frame.origin.x = x
                x = x + containerView.frame.size.width
                scrollView.addSubview(containerView)
                NetworkManager.getDataFromUrl(url: URL(string: imageURLString)!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        containerView.postImage.image = UIImage(data: data)
                    }
                }
            }
            scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(numberOfImages)), height: scrollView.frame.size.height)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: (self.frame.size.width * CGFloat(numberOfImages)), height: scrollView.frame.size.height)
        var x : CGFloat = 0.0
        for view in scrollView.subviews {
            view.frame.size.width = self.frame.width
            view.frame.origin.x = x
            x = x + view.frame.size.width
        }
    }
}
