//
//  GenericCollectionView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 12/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

func makeDefaultLayout() -> UICollectionViewLayout {
    return UICollectionViewFlowLayout()
}

class GenericCollectionViewController<V: UIView, C: ContainerCollectionViewCell<V>>: UICollectionViewController {

    init(viewType: V.Type) {
        super.init(collectionViewLayout: makeDefaultLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var numberOfItems: () -> Int = { 0 } {
        didSet {
            collectionView?.reloadData()
        }
    }

    var configureView: (IndexPath, V) -> () = { _, _ in } {
        didSet {
            collectionView?.reloadData()
        }
    }

    var didSelectView: (IndexPath, V) -> () = { _, _ in }
    
}


