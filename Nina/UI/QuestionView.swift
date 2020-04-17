//
//  QuestionView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 14/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    var question: String
    
    lazy var titleLabel: UILabel = {
        let label = BoldLabel().notTranslating()
        label.text = question
        return label
    }()
    
    init(question: String) {
        self.question = question
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuestionView {
    
    fileprivate func setupViews() {
        titleLabel.fill(view: self, margin: Margin.default)
    }
    
}
