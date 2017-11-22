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
        for image in postImages {
            let imageView = UIImageView.init(image: image)
//            imageView.frame.size = scrollView.frame.size
//            imageView.frame.origin.y = 0
//            imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }
    }
}
