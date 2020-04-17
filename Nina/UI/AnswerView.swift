//
//  AnswerView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 16/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class AnswerView: UIView {
    
    enum AnswerType {
        case shortText
        case longText
        case options([String])
    }
    
    var type: AnswerType
    
    init(type: AnswerType) {
        self.type = type
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AnswerView {
    
    fileprivate func setupViews() {
        
    }
    
}
