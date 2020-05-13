//
//  InitialCollectionViewLayout.swift
//  Nina
//
//  Created by Emannuel Carvalho on 12/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class InitialColectionViewLayout: UICollectionViewLayout {
    
    let deviceWidth = UIScreen.main.bounds.width
    lazy var deviceHeight: CGFloat = {
        return self.collectionView?.frame.height ?? UIScreen.main.bounds.height
    }()
    let treeSize = CGFloat(200)
    let cellSize = CGFloat(100)
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var yOffsets = {
        return [
            CGFloat(50), CGFloat(20), CGFloat(50),
            CGFloat(self.deviceHeight / 2 - self.treeSize / 2),
            CGFloat(self.deviceHeight - (50 + self.cellSize)),
            CGFloat(self.deviceHeight - (20 + self.cellSize)),
            CGFloat(self.deviceHeight - (50 + self.cellSize))
        ]
    }()
    
    fileprivate lazy var xOffsets = {
        return [
            CGFloat(20), CGFloat(self.deviceWidth / 2 - self.cellSize / 2), CGFloat(self.deviceWidth - (cellSize + 20)),
            CGFloat(self.deviceWidth / 2 - self.treeSize / 2),
            CGFloat(20), CGFloat(self.deviceWidth / 2 - self.cellSize / 2), CGFloat(self.deviceWidth - (cellSize + 20)),
        ]
    }()
    
    override func prepare() {
        guard cache.isEmpty,
            let collectionView = collectionView
            else {
                return
        }
        
        let number = collectionView.numberOfItems(inSection: 0)
        
        for item in 0..<number {
            let indexPath = IndexPath(item: item, section: 0)
            
            let frame = CGRect(x: xOffsets[indexPath.item],
                               y: yOffsets[indexPath.item],
                               width: (number / 2) == indexPath.item ? treeSize : cellSize,
                               height: (number / 2) == indexPath.item ? treeSize : cellSize)
            let insetFrame = frame.insetBy(dx: 0, dy: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: deviceWidth, height: collectionView?.frame.height ?? 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var displayedAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
          if attributes.frame.intersects(rect) {
            displayedAttributes.append(attributes)
          }
        }
        
        return displayedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes()
        attributes.size = CGSize(width: 100, height: 100)
        cache.append(attributes)
        return attributes
    }
    
}

