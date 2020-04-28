//
//  SimpleTextView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 08/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class SimpleTextView: UIView {
    
    enum State {
        case disabled
        case enabled
    }
    
    var text: String {
        didSet {
            updateUI()
        }
    }
    
    var state: State {
        didSet {
            updateUI()
        }
    }
    
    lazy var textLabel: UILabel = {
        let label = Label().notTranslating()
        label.text = text
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = deviceWidth
        return label
    }()
    
    init(text: String, state: State = .enabled) {
        self.text = text
        self.state = state
        super.init(frame: .zero)
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SimpleTextView {
    
    fileprivate func updateUI() {
        textLabel.text = self.text
        switch state {
        case .disabled:
            textLabel.textColor = .gray
        case .enabled:
            textLabel.textColor = .black
        }
    }
    
    fileprivate func setupViews() {
        textLabel.fill(view: self, margin: Margin.default)
    }
    
}
