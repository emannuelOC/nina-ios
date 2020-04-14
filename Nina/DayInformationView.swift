//
//  DayInformationView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class DayInformationView: UIView {
    
    lazy var soilView: SelectionView = {
        let selectionView = SelectionView(choices: soilButtons, delegate: self).notTranslating()
        return selectionView
    }()
    
    lazy var branchesView: SelectionView = {
        let selectionView = SelectionView(choices: branchButtons, delegate: self).notTranslating()
        return selectionView
    }()
    
    let soilButtons = ["Exercícios", "Alimentação", "Sono"]
    let branchButtons = ["Leitura", "Idiomas", "Habilidades"]
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DayInformationView {
    
    fileprivate func setupViews() {
        backgroundColor = Color.secondary
        
        addSubview(soilView)
        addSubview(branchesView)
        
        soilView.attachToTop(at: self)
        branchesView.attachToBottom(at: self)
        
        soilView.bottomAnchor.constraint(lessThanOrEqualTo: branchesView.topAnchor).isActive = true
    }
    
    fileprivate func showSelection(for choice: String) {
        print(choice)
    }
    
}

extension DayInformationView: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelect choice: String) {
        selectionView.disselect()
        showSelection(for: choice)
    }
    
}
