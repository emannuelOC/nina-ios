//
//  ShortTextInputView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 16/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class ShortTextInputView: UIView {
    
    var placeholder: String? {
        didSet {
            updateUI()
        }
    }
    
    var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField().notTranslating()
        textField.delegate = self
        return textField
    }()
    
    init(placeholder: String? = nil, text: String? = nil) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShortTextInputView {
    
    fileprivate func setupViews() {
        textField.fill(view: self)
        heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    fileprivate func updateUI() {
        textField.placeholder = placeholder
        textField.text = text
    }
    
}

extension ShortTextInputView {
    
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
}

extension ShortTextInputView: UITextFieldDelegate {
    
    
    
}
