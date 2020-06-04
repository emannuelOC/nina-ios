//
//  TreeViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 02/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class TreeViewController: UIViewController {
    
    var branchesScore: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var soilScore: Double = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    lazy var treeView = TreeView().notTranslating()
    
    lazy var branchesTitleView = SimpleTitleView(title: "-")
    
    lazy var soilTitleView = SimpleTitleView(title: "-")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.secondary
        
        let soilView = SimpleTextView(text: NSLocalizedString("The soil represents the health of your brain tissue", comment: "")).notTranslating()
        soilView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160).isActive = true
        
        view.fill(with: [
            treeView,
            branchesTitleView,
            SimpleTextView(text: NSLocalizedString("The branches represent your cognitive reserve", comment: "")),
            soilTitleView,
            soilView
        ], margin: 0)
        
        treeView.constraintSquare(side: 200)
        treeView.layer.cornerRadius = 100
        treeView.backgroundColor = Color.secondary
        
    }
    
    fileprivate func updateUI() {
        treeView.branchesScore = branchesScore
        treeView.soilScore = soilScore
        let branchesString = "\(String(format: "%.2f", branchesScore))"
        let soilString = "\(String(format: "%.2f", soilScore))"
        branchesTitleView.title = String(format: NSLocalizedString("Branches: %@", comment: ""), branchesString)
        soilTitleView.title = String(format: NSLocalizedString("Soil: %@", comment: ""), soilString)
    }
    
}
