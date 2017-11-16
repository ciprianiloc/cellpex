//
//  ProductsManager.swift
//  cellpex
//
//  Created by Ciprian Iloc on 16/11/2017.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit


final class  ProductsManager : NSObject{
    var products = [ProductModel]()
    var originalEndPoint : String
    var searchValue : String?
    var lastRequestedPage = 1
    private var responseHandler : (()->())?
    
    init(endPoint : String) {
        originalEndPoint = endPoint
        searchValue = nil
    }
    
    func requestFirstTimeProducts(successHandler: @escaping ()->()) {
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
        let endPoint = (searchValue != nil) ? WebServices.getProductsSearch : originalEndPoint
        NetworkManager.getProduct(search: searchValue, endPoint: endPoint, successHandler: {[weak self](productsArray : [[String: Any?]?]?) in
            self?.products.removeAll()
            self?.loadProducts(productsArray: productsArray)
        }) { (errorMessage: String) in
            
        }
    }
    
    func reloadProducts(successHandler: @escaping ()->()) {
        self.lastRequestedPage = 1
        self.responseHandler = successHandler
        searchValue = nil
        NetworkManager.getProduct(search: nil, endPoint: originalEndPoint, successHandler: {[weak self](productsArray : [[String: Any?]?]?) in
            self?.products.removeAll()
            self?.loadProducts(productsArray: productsArray)
        }) { (errorMessage: String) in

        }
    }
    
    func requestNextPage(successHandler: @escaping ()->()) {
        lastRequestedPage = lastRequestedPage + 1
        self.responseHandler = successHandler
        let endPoint = ((searchValue != nil) ? WebServices.getProductsSearch : originalEndPoint) + "?pag=\(lastRequestedPage)"
        NetworkManager.getProduct(search: searchValue, endPoint: endPoint, successHandler: {[weak self](productsArray : [[String: Any?]?]?) in
            self?.loadProducts(productsArray: productsArray)
        }) { (errorMessage: String) in
        }
    }
    
    private func loadProducts(productsArray:[[String: Any?]?]?) {
        if let listOfProducts = productsArray {
            for product in listOfProducts {
                let productModel = ProductModel.init(dictionary: product)
                if productModel.isValidProduct {
                    self.products.append(productModel)
                }
            }
        }
        self.responseHandler?()
    }
    
}
