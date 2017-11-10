//
//  ProductDetailsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SafariServices

class CharacteristicCell: UICollectionViewCell {
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var productCharacteristicLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
}

class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productPageController: UIPageControl!
    
    @IBAction func productPageHasChanged(_ sender: Any) {
    }
    
}

class ProviderInfoCell: UICollectionViewCell {
    @IBOutlet weak var providerImageView: UIImageView!
    
    @IBOutlet weak var providerNameLabel: UILabel!
    
    @IBOutlet weak var providerLinkLabel: UILabel!
    
    @IBOutlet weak var providerLocationLable: UILabel!
    
    @IBOutlet weak var providerNumber: UILabel!
}

class SendMessageCell: UICollectionViewCell {
    @IBOutlet weak var messageOptionLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var goToOrderButton: UIButton!
}

class AditionalDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var additionalDetailsLabel: UILabel!
}


class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productDetailsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CharacteristicCell", for: indexPath) as! CharacteristicCell
            
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AditionalDetailsCell", for: indexPath) as! AditionalDetailsCell
            
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProviderInfoCell", for: indexPath) as! ProviderInfoCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SendMessageCell", for: indexPath) as! SendMessageCell
            return cell
        }
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = (UIDevice.current.userInterfaceIdiom == .pad) ?(collectionView.frame.width - 10)/2 : collectionView.frame.width - 10;
        return CGSize(width: widthPerItem, height: 109)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
}

