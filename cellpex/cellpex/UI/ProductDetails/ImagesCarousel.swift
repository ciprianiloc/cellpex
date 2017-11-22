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
    
    func addImages(images : [UIImage]) {
        postImages.append(contentsOf: images)
        self.loadImageCarousel()
    }
    
    private func loadImageCarousel(){
        var lastImageViewRight : NSLayoutXAxisAnchor?
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
}
