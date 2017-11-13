//
//  ProductDetailsLayout.swift
//  cellpex
//
//  Created by Ciprian Iloc on 11/12/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

protocol ProductDetailsLayoutDelegate: class {
    // 1. Method to ask the delegate for the height of the image
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class ProductDetailsLayout: UICollectionViewLayout {
    //1. Pinterest Layout Delegate
    weak var delegate: ProductDetailsLayoutDelegate!
    
    //2. Configurable properties
    fileprivate var numberOfColumns = 1
    fileprivate var cellPadding: CGFloat = 0
    
    //3. Array to keep a cache of attributes.
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //4. Content height and size
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
//        guard cache.isEmpty == true else {
//            return
//        }
        let productImageLastY = setupForProductImageSection()
        let productCharacteristicsLastY = setupForProductCharacteristicsSection(startY: productImageLastY)
        let additionalDetailsLastY = setupForAdditionalDetailsSection(startY: productCharacteristicsLastY)
        let startYForProductProviderSection = (UIDevice.current.userInterfaceIdiom == .pad) ? productImageLastY : additionalDetailsLastY
        let productProviderSectionLastY = setupForProductProviderSection(startY: startYForProductProviderSection)
        let _ = setupForSendMessageSection(startY: productProviderSectionLastY)
    }
    
    private func setupForProductImageSection () -> CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        let indexPath = IndexPath(item: 0, section: 0)
        let cellHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
        let height = cellPadding * 2 + cellHeight
        let frame = CGRect(x: 0, y: 0, width: contentWidth, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6. Updates the collection view content height
        contentHeight = frame.maxY
        return contentHeight
    }
    
    private func setupForProductCharacteristicsSection(startY: CGFloat) -> CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        var yOffset = startY
        for item in 0 ..< collectionView.numberOfItems(inSection: 1) {
            
            let indexPath = IndexPath(item: item, section: 1)
            
            // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
            let cellHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellHeight
            let width = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : contentWidth
            let frame = CGRect(x: 0, y: yOffset, width: width, height: height)
            let insetFrame = frame.insetBy(dx: 0 , dy: 0)
            
            // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6. Updates the collection view content height
            contentHeight = frame.maxY
            yOffset = yOffset + height
        }
        return yOffset
    }
    
    private func setupForAdditionalDetailsSection(startY: CGFloat) -> CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        let indexPath = IndexPath(item: 0, section: 2)
        let cellHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
        let height = cellPadding * 2 + cellHeight
        let width = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : contentWidth
        let frame = CGRect(x: 0, y: startY, width: width, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6. Updates the collection view content height
        contentHeight =  frame.maxY
        return contentHeight
    }
    
    private func setupForProductProviderSection(startY: CGFloat) -> CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        let indexPath = IndexPath(item: 0, section: 3)
        let cellHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
        let height = cellPadding * 2 + cellHeight
        let width = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : contentWidth
        let x = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : 0
        let frame = CGRect(x: x, y: startY, width: width, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6. Updates the collection view content height
        contentHeight =  frame.maxY
        return contentHeight
    }
    
    private func setupForSendMessageSection(startY: CGFloat) -> CGFloat{
        guard let collectionView = collectionView else {
            return 0
        }
        let indexPath = IndexPath(item: 0, section: 4)
        let cellHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
        let height = cellPadding * 2 + cellHeight
        let width = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : contentWidth
        let x = (UIDevice.current.userInterfaceIdiom == .pad) ? contentWidth/2 : 0
        let frame = CGRect(x: x, y: startY, width: width, height: height)
        let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
        
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        cache.append(attributes)
        
        // 6. Updates the collection view content height
        contentHeight = max(contentHeight, frame.maxY)
        return contentHeight
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
