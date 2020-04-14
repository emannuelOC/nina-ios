//
//  SimpleTitleView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 08/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class SimpleTitleView: UIView {
    
    var title: String {
        didSet {
            updateUI()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = BoldLabel().notTranslating()
        label.text = self.title
        return label
    }()
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SimpleTitleView {
    
    fileprivate func updateUI() {
        self.titleLabel.text = self.title
    }
    
    fileprivate func setupViews() {
        titleLabel.fill(view: self, margin: Margin.default)
        heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
    
}
