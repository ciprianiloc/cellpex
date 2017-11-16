//
//  ListOfProductsViewController.swift
//  cellpex
//
//  Created by Ciprian Iloc on 31/10/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit
import SafariServices
class ListOfProductsViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    var productCollectionView :UICollectionView? {
        return nil
    }

    let refreshControl = UIRefreshControl()

    var footerView:RefreshFooterView?
    var isLoading:Bool = false
    var selectedProductIndex = 0
    let productManager = ProductsManager(endPoint: WebServices.getProducts)
    
    let footerViewReuseIdentifier = "RefreshFooterView"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productCollectionView?.addSubview(refreshControl)
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        searchController.searchBar.placeholder = "Type mode"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        self.addNavigationTitleViewImage(UIImage(named: "login_logo_image")!)
        self.productCollectionView?.register(UINib(nibName: "RefreshFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.refreshControl.attributedTitle = NSAttributedString.init(string: "pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ListOfProductsViewController.handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.productCollectionView?.collectionViewLayout.invalidateLayout()
        self.view.setNeedsDisplay()
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
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func productsReceived() {
        DispatchQueue.main.async {[weak self] in
            self?.productCollectionView?.reloadData()
        }
    }
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        searchController.searchBar.text = nil
        productManager.reloadProducts { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            self?.productsReceived()
        }
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
        let imageUrl = product.imageUrl ?? ""
        getDataFromUrl(url: URL(string: imageUrl)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.productImageView.image = UIImage(data: data)
            }
        }
        
        cell.productDateLabel.text = product.date
        let redirectTitile = product.user
        cell.productRedirectButton.setTitle(redirectTitile, for: .normal)
        cell.productSatusLabel.text = product.cond
        cell.productPriceLabel.text = product.price
        cell.productDescriptionLabel.text = product.name
        cell.productPropertiesLabel.text = product.nameExtra
        cell.productRedirectAction = {[weak self] in
            guard let `self` = self else {
                return;
            }
            let redirectURL = URLConstant.redirectURL
            if let url = URL(string: redirectURL) {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! RefreshFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
}

extension ListOfProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProductIndex = indexPath.row
        self.performSegue(withIdentifier: "showProductDetails", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
}

extension ListOfProductsViewController : UIScrollViewDelegate {
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                self.isLoading = true
                self.footerView?.startAnimate()
                self.productManager.requestNextPage {[weak self] in
                    self?.productsReceived()
                    self?.isLoading = false
                }

            }
        }
    }
}

extension ListOfProductsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.productManager.searchValue = searchBar.text
        self.productManager.requestFirstTimeProducts {[weak self] in
            self?.productsReceived()
        }
    }
}
