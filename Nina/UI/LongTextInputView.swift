//
//  LongTextInputView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 16/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class LongTextInputView: UIView {
    
    var text: String? {
        return textView.text
    }
    
    lazy var textView: UITextView = {
        let textView = UITextView().notTranslating()
        return textView
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LongTextInputView {
    
    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
    
}

extension LongTextInputView {
    
    fileprivate func setupViews() {
        textView.fill(view: self, margin: Margin.default)
    }
    
}
