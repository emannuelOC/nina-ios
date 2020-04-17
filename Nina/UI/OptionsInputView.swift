//
//  OptionsInputView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 16/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

protocol OptionsInputViewDelegate: class {
    func optionsInputView(_ optionsInputView: OptionsInputView, didSelect option: String)
}

class OptionsInputView: UIView {
    
    var options: [String]
    
    weak var delegate: OptionsInputViewDelegate?
    
    lazy var selectionView: SelectionView = {
        let selectionView = SelectionView(choices: options, delegate: self).notTranslating()
        return selectionView
    }()
    
    init(options: [String]) {
        self.options = options
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OptionsInputView {
    
    fileprivate func setupViews() {
        selectionView.fill(view: self)
    }
    
}

extension OptionsInputView: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelect choice: String) {
        delegate?.optionsInputView(self, didSelect: choice)
    }
    
}
