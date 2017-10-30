//
//  HomeViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/27/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var colectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        searchController.searchBar.placeholder = "Type mode"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
//        self.navigationItem.hidesBackButton = true
//        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "hamburger_icon"), style: .plain, target: self, action: #selector(HomeViewController.back(sender:)))
//        self.navigationItem.leftBarButtonItem = leftBarButton
    }
 
    @objc func back(sender: UIBarButtonItem) {

        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        cell.productImageView.image = UIImage.init(named: "teset_product_icon")
        cell.productDateLabel.text = "28, Oct"
        cell.productProvider.text = "servicegsm"
        cell.productSatusLabel.text = "New"
        cell.productPriceLabel.text = "320 USD"
        cell.productDescriptionLabel.text = "Apple iPhone 6s"
        cell.productPropertiesLabel.text = "32 GB"
        return cell;
    }
    
}

extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (UIDevice.current.userInterfaceIdiom == .pad) ?(collectionView.frame.width - 10)/2 : collectionView.frame.width - 10;
        return CGSize(width: widthPerItem, height: 109)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
}

