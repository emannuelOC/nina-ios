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
        
        view.fill(with: [
            treeView,
            branchesTitleView,
            SimpleTextView(text: "Os ramos representam a sua reserva cognitiva"),
            soilTitleView,
            SimpleTextView(text: "O solo representa a saúde do seu tecido cerebral"),
            SimpleTextView(text: "")
        ])
        
        treeView.constraintSquare(side: 200)
        treeView.layer.cornerRadius = 100
        treeView.backgroundColor = Color.secondary
        
        treeView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(debug))
        )
    }
    
    fileprivate func updateUI() {
        treeView.branchesScore = branchesScore
        treeView.soilScore = soilScore
        branchesTitleView.title = "Ramos: \(String(format: "%.2f", branchesScore))"
        soilTitleView.title = "Solo: \(String(format: "%.2f", soilScore))"
    }
    
    @objc fileprivate func debug() {
        print("hello")
    }
    
}
