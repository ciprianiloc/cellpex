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
    
    let placeholderLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        sendMessageButton.isEnabled = (messageTextView.text.isEmpty == false)
        placeholderLabel.text = "Type your message..."
        
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewHasChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    @objc func textViewHasChanged() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        sendMessageButton.isEnabled = !messageTextView.text.isEmpty
    }
    
}


class AditionalDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var additionalDetailsLabel: UILabel!
}


class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productDetailsCollectionView: UICollectionView!
    private let characteristics = [("Condition", "Refurbished | 64 GB"), ("Carrier","Unlocked"), ("Price","196.00 USD / Item"),("Availability", "Physical Stock"), ("Stock", "200 Items"), ("Packing", "Blister Packed"), ("Market", "Other"), ("Date", "09,Nov 2017"), ("Location","Hong Kong, hongkong")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if let layout = productDetailsCollectionView?.collectionViewLayout as? ProductDetailsLayout {
            layout.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.productDetailsCollectionView?.collectionViewLayout.invalidateLayout()
        self.view.setNeedsDisplay()
    }
    
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return characteristics.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            cell.productImageView.backgroundColor = UIColor.orange
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CharacteristicCell", for: indexPath) as! CharacteristicCell
            cell.productInfoLabel.text = characteristics[indexPath.row].0
            cell.productCharacteristicLabel.text = characteristics[indexPath.row].1
            cell.underLineView.isHidden = indexPath.row == characteristics.count - 1
            cell.backgroundColor = UIColor.gray
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AditionalDetailsCell", for: indexPath) as! AditionalDetailsCell
            cell.additionalDetailsLabel.text = "Additional details text Additional details text Additional details text Additional details text"
            cell.backgroundColor = UIColor.red
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProviderInfoCell", for: indexPath) as! ProviderInfoCell
            cell.providerNameLabel.text = "SKYRISE DISTRIBUTION LIMITED"
            cell.providerLinkLabel.text = "solidgsm"
            cell.providerNumber.text = "(3)"
            cell.providerLocationLable.text = "Hong Kong, hongkong"
            cell.providerImageView.backgroundColor = UIColor.orange
            cell.backgroundColor = UIColor.yellow
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SendMessageCell", for: indexPath) as! SendMessageCell
            cell.messageOptionLabel.text = "General Availability"
            cell.backgroundColor = UIColor.orange
            return cell
        }
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    
}

//extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let widthPerItem = (UIDevice.current.userInterfaceIdiom == .pad) ?(collectionView.frame.width - 10)/2 : collectionView.frame.width - 10;
//        if indexPath.section == 0 {
//            return CGSize(width: collectionView.frame.width, height: 240)
//        } else if indexPath.section == 1 {
//            return CGSize(width: widthPerItem, height: 30)
//        } else if indexPath.section == 4 {
//            return CGSize(width: widthPerItem, height:250)
//        }
//        return CGSize(width: widthPerItem, height: 90)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 0;
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 1 {
//            return CGSize.zero
//        }
//        return CGSize(width: self.view.frame.width, height:5)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.size.width, height: 0)
//    }
//}

extension ProductDetailsViewController : ProductDetailsLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        } else if indexPath.section == 1 {
            return 30
        } else if indexPath.section == 4 {
            return 250;
        }
        return 90
    }
}
