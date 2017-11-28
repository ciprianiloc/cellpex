//
//  ProductDetailsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 30/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class CharacteristicCell: UICollectionViewCell {
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var productCharacteristicLabel: UILabel!
    @IBOutlet weak var underLineView: UIView!
}

class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imagesCarousel: ImagesCarousel!
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
    @IBOutlet weak var messageOptionArrowImage: UIImageView!
    @IBOutlet weak var selectSubjectView: UIView!
    
    let placeholderLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        sendMessageButton.isEnabled = !messageTextView.text.isEmpty
        let buttonCollor = sendMessageButton.isEnabled ? UIColor.init(red: 25.0/255.0, green: 74.0/255.0, blue: 177.0/255.0, alpha: 1.0) : UIColor.init(white: 0.86, alpha: 1.0)
        self.sendMessageButton.backgroundColor = buttonCollor
        placeholderLabel.text = "Type your message..."
        
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (messageTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        messageTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        NotificationCenter.default.addObserver(self, selector: #selector(self.textViewHasChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        selectSubjectView.layer.shadowColor = UIColor.lightGray.cgColor
        selectSubjectView.layer.shadowRadius = 2
        selectSubjectView.layer.shadowOpacity = 0.5
        
        messageTextView.layer.shadowColor = UIColor.lightGray.cgColor
        messageTextView.layer.shadowOpacity = 0.3
        messageTextView.layer.shadowRadius = 1
    }
    
    @objc func textViewHasChanged() {
        placeholderLabel.isHidden = !messageTextView.text.isEmpty
        sendMessageButton.isEnabled = !messageTextView.text.isEmpty
        let buttonCollor = sendMessageButton.isEnabled ? UIColor.init(red: 25.0/255.0, green: 74.0/255.0, blue: 177.0/255.0, alpha: 1.0) : UIColor.init(white: 0.86, alpha: 1.0)
        self.sendMessageButton.backgroundColor = buttonCollor
    }
    
    
    
}


class AditionalDetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var additionalDetailsLabel: UILabel!
}


class ProductDetailsViewController: UIViewController {
    private var productDetailsModel : ProductDetailsModel?
    @IBOutlet weak var productDetailsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewButtomConstraints: NSLayoutConstraint!
    private var characteristics = [(String, String)]()
    private var selectSubjectActionSheet: UIAlertController?
    private var shouldUseHeightZero = true
    private var postImages = [UIImage]()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if let layout = productDetailsCollectionView?.collectionViewLayout as? ProductDetailsLayout {
            layout.delegate = self
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        spinner.startAnimating()
        self.productDetailsModel = nil        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.setScreenName("PostDetailsScreen", screenClass: "ProductDetailsViewController")
    }
    
    func handleErrorReceived(errorMessage: String) {
        print("\(errorMessage)")
    }
    
    func handleSuccessReceived(productDetails: [String : Any?]?) {
        self.productDetailsModel = ProductDetailsModel.init(dictionary: productDetails)
        if let condition = self.productDetailsModel?.condition {
             self.characteristics.append(("Condition", condition))
        }
        if let carrier = self.productDetailsModel?.carrierAndSimStatus {
            self.characteristics.append(("Carrier", carrier))
        }
        if let price = self.productDetailsModel?.price {
            self.characteristics.append(("Price", "\(price) / Item"))
        }
        if let availability = self.productDetailsModel?.availability {
            self.characteristics.append(("Availability", availability))
        }
        if let stock = self.productDetailsModel?.quantity {
            self.characteristics.append(("Stock", "\(stock) Items"))
        }
        if let packing = self.productDetailsModel?.pack {
            self.characteristics.append(("Packing", packing))
        }
        if let market = self.productDetailsModel?.market {
            self.characteristics.append(("Market", market))
        }
        if let date = self.productDetailsModel?.date {
            self.characteristics.append(("Date", date))
        }
        if let location = self.productDetailsModel?.userState {
            self.characteristics.append(("Location", location))
        }
        DispatchQueue.main.async { [weak self] in
            self?.spinner.stopAnimating()
            self?.shouldUseHeightZero = false
            self?.productDetailsCollectionView.reloadData()
        }
        if let imagesUrls = self.productDetailsModel?.imagesUrl, imagesUrls.count > 0 {
            let getImagesQueue = OperationQueue()
            getImagesQueue.maxConcurrentOperationCount = 1
            for imageURL in imagesUrls {
                let getImageOperation = GetImageOperation(URLString: imageURL, networkOperationCompletionHandler: { [weak self](data:Data?, urlResponse: URLResponse?, error:Error?) in
                    if let dataImage = data {
                        if let image = UIImage(data: dataImage) {
                            self?.postImages.append(image)
                        }
                    }
                })
                getImagesQueue.addOperation(getImageOperation)
            }
            getImagesQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async { [weak self] in
                self?.productDetailsCollectionView.reloadData()
            }
        } else {
            if let urlString = self.productDetailsModel?.imageUrl {
                if let url = URL(string: urlString) {
                NetworkManager.getDataFromUrl(url: url, completion: { [weak self](data:Data?, urlResponse: URLResponse?, error:Error?) in
                    if let dataImage = data {
                        if let image = UIImage(data: dataImage) {
                            self?.postImages.append(image)
                            DispatchQueue.main.async {
                                self?.productDetailsCollectionView.reloadData()
                            }
                        }
                    }
                })
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.productDetailsCollectionView?.collectionViewLayout.invalidateLayout()
        selectSubjectActionSheet?.dismiss(animated: false, completion: nil)
        self.view.setNeedsDisplay()
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        collectionViewButtomConstraints.constant = keyboardHeight
        DispatchQueue.main.async {
            self.productDetailsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 4), at: UICollectionViewScrollPosition.bottom, animated: true)
        }
    
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        collectionViewButtomConstraints.constant = 0
    }
    @IBAction func goToOrderAction(_ sender: Any) {
        let postId = productDetailsModel?.id ?? ""
        NetworkManager.redirectToWeb(parentVC: self, endPoint: "offer&id=\(postId)")
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let postId = productDetailsModel?.id ?? ""
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        if let sendMessageCell = productDetailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as? SendMessageCell {
            let subject = sendMessageCell.messageOptionLabel.text ?? "General Availability"
            let message = sendMessageCell.messageTextView.text ?? ""

            NetworkManager.sendMessage(postId: postId, subject: subject, message: message) { [weak self](message: String) in
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
                }))
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    sendMessageCell.messageOptionLabel.text = "General Availability"
                    sendMessageCell.messageTextView.text = nil
                    sendMessageCell.sendMessageButton.isEnabled = false
                    self?.present(alert, animated: true)
                    self?.view.isUserInteractionEnabled = true
                }
            }
        } else {
            self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    @IBAction func redirectToUser(_ sender: Any) {
        let postUserId = productDetailsModel?.userId ?? ""
        NetworkManager.redirectToWeb(parentVC: self, endPoint: "user&id=\(postUserId)")
    }
    
    @IBAction func selectSubject(_ sender: Any) {
        let cell = productDetailsCollectionView.cellForItem(at: IndexPath(row: 0, section: 4)) as! SendMessageCell
        selectSubjectActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let subjectOptions = ["General Availability", "Payment Inquiry", "Shipping Inquiry"]
        selectSubjectActionSheet?.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        for subjectOption in subjectOptions {
            selectSubjectActionSheet?.addAction(UIAlertAction.init(title: subjectOption, style: .default, handler: { (action) in
                cell.messageOptionLabel.text = subjectOption
            }))
        }
        selectSubjectActionSheet?.popoverPresentationController?.sourceView = cell.contentView;
        selectSubjectActionSheet?.popoverPresentationController?.sourceRect = CGRect.init(x: cell.messageOptionArrowImage.frame.origin.x + cell.messageOptionArrowImage.frame.size.width, y: cell.messageOptionArrowImage.frame.origin.y + cell.messageOptionArrowImage.frame.size.height, width: 1, height: 1)
        
        self.present(selectSubjectActionSheet!, animated: true)
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
            if postImages.count > 0 {
                cell.imagesCarousel.addImages(images: postImages)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CharacteristicCell", for: indexPath) as! CharacteristicCell
            cell.productInfoLabel.text = characteristics[indexPath.row].0
            cell.productCharacteristicLabel.text = characteristics[indexPath.row].1
            cell.underLineView.isHidden = indexPath.row == characteristics.count - 1
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AditionalDetailsCell", for: indexPath) as! AditionalDetailsCell
            cell.additionalDetailsLabel.text = self.productDetailsModel?.details
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ProviderInfoCell", for: indexPath) as! ProviderInfoCell
            if let providerName = self.productDetailsModel?.userCompany {
                cell.providerNameLabel.text = providerName
            }
            if let user = self.productDetailsModel?.user {
                cell.providerLinkLabel.text = user
            }
            let userFeedback = self.productDetailsModel?.userFeedbackScore ?? "0"
            cell.providerNumber.text = "(\(userFeedback))"
            cell.providerLocationLable.text = self.productDetailsModel?.providerAddress
            if let userLogo = self.productDetailsModel?.userCompanyLogoUrl {
                NetworkManager.getDataFromUrl(url: URL(string: userLogo)!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        cell.providerImageView.image = UIImage(data: data)
                    }
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SendMessageCell", for: indexPath) as! SendMessageCell
            cell.messageOptionLabel.text = "General Availability"
            return cell
        }
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    
}

extension ProductDetailsViewController : ProductDetailsLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if shouldUseHeightZero {
            return 0
        }
        if indexPath.section == 0 {
            return 280
        } else if indexPath.section == 1 {
            return 30
        } else if indexPath.section == 2 {
            if (self.productDetailsModel?.details?.isEmpty ?? true) {
                return 0
            }
            return 100
        } else if indexPath.section == 3 {
            return 90
        } else if indexPath.section == 4 {
            return 280;
        }
        return 90
    }
}
