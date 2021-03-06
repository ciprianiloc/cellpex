//
//  ListOfProductsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 31/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ListOfProductsViewController: BaseViewController {

    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var collectionViewButtomConstraint: NSLayoutConstraint!
    @IBOutlet weak var unreadMessagesLabel: UILabel!

    let refreshControl = UIRefreshControl()
    let bottomRefreshControl = UIRefreshControl()
    var selectedProductIndex = 0
    let productManager = ProductsManager(endPoint: WebServices.getProducts)
    var valueForNoFilter = "Wholesale Lots"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.addNavigationTitleViewImage(UIImage(named: "login_logo_image")!)
        searchController.searchBar.placeholder = "Type mode"
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        searchController.searchBar.delegate = self

        self.refreshControl.attributedTitle = NSAttributedString.init(string: "pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ListOfProductsViewController.handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        self.bottomRefreshControl.attributedTitle = NSAttributedString.init(string: "pull to load more")
        self.bottomRefreshControl.addTarget(self, action: #selector(ListOfProductsViewController.bottomRefreshControl(refreshControl:)), for: UIControl.Event.valueChanged)
        collectionView.bottomRefreshControl = bottomRefreshControl
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.view.setNeedsDisplay()
    }
    
    func infoLabel(hiddenStatus:Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ("showProductDetails" == segue.identifier) {
            let productDetails = segue.destination as! ProductDetailsViewController
            let productModel = productManager.products[selectedProductIndex]
            productDetails.title = productModel.name
            NetworkManager.getProductDetails(product: productModel, successHandler: { (productInfo:[String : Any?]?) in
                productDetails.handleSuccessReceived(productDetails: productInfo)
            }, errorHandler: { (errorMessage:String) in
                productDetails.handleErrorReceived(errorMessage: errorMessage)
            })
        }
    }

    func productsReceived() {
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        guard displayNoInternetConnectionAlertIfNeeded() == false else {
            self.refreshControl.endRefreshing()
            return
        }
        searchController.searchBar.text = nil
        self.infoLabel(hiddenStatus: false)
        productManager.reloadProducts { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.filterLabel.text = self?.valueForNoFilter
                let productCount = self?.productManager.products.count ?? 0
                self?.infoLabel(hiddenStatus: (productCount > 0))
            }
            self?.productsReceived()
        }
    }
    @objc func bottomRefreshControl(refreshControl: UIRefreshControl) {
        guard displayNoInternetConnectionAlertIfNeeded() == false else {
            self.bottomRefreshControl.endRefreshing()
            return
        }
        self.productManager.requestNextPage {[weak self] in
            self?.bottomRefreshControl.endRefreshing()
            self?.productsReceived()
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        collectionViewButtomConstraint.constant = keyboardHeight
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        collectionViewButtomConstraint.constant = 0
    }
}

extension ListOfProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productManager.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let product = productManager.products[indexPath.row]
        if let productImage = product.image {
            cell.productImageView.image = productImage
        } else {
            let imageUrl = product.imageUrl ?? ""
            NetworkManager.getDataFromUrl(url: URL(string: imageUrl)!) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    let image = UIImage(data: data)
                    cell.productImageView.image = image
                    self.productManager.products[indexPath.row].image = image
                }
            }
        }
        
        cell.productDateLabel.text = product.date
        cell.userLabel.text = product.user
        cell.userLabel.tag = indexPath.row
        cell.productSatusLabel.text = product.cond
        cell.productPriceLabel.text = product.price
        cell.productDescriptionLabel.text = product.name
        cell.productPropertiesLabel.text = product.nameExtra
        cell.userTapAction = { [weak self] in
            guard let `self` = self else { return }
            if let postUserId = self.productManager.products[indexPath.row].userId {
                NetworkManager.redirectToWeb(parentVC: self, endPoint: "user&id=\(postUserId)")
            }
        }
        return cell;
    }
}

extension ListOfProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProductIndex = indexPath.row
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
}

extension ListOfProductsViewController: UICollectionViewDelegateFlowLayout {
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

extension ListOfProductsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.productManager.searchValue = searchBar.text
        self.productManager.requestFirstTimeProducts {[weak self] in
            DispatchQueue.main.async {
                self?.filterLabel.text = self?.productManager.searchValue
            }
            self?.productsReceived()
        }
    }
}
