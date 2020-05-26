//
//  TreeCollectionViewCell.swift
//  Nina
//
//  Created by Emannuel Carvalho on 12/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class TreeViewCell: UICollectionViewCell {
    
    lazy var treeView = TreeView().notTranslating()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(branchesScore: Double, soilScore: Double) {
        treeView.branchesScore = branchesScore
        treeView.soilScore = soilScore
    }
    
    fileprivate func setupViews() {
        layer.borderWidth = 10
        layer.borderColor = Color.border.cgColor
        layer.masksToBounds = false
        backgroundColor = Color.secondary
        contentView.backgroundColor = Color.secondary
        treeView.fill(view: contentView)
    }
    
}
