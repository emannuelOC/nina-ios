//
//  PrimaryButtonView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class PrimaryButtonView: UIView {
    
    var title: String {
        didSet {
            updateUI()
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
            .notTranslating()
            .backgrounded(color: Color.primary)
            .radiusConfigured(radius: Radius.normal)
        button.titleLabel?.font = Font.regular
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    init(title: String, target: Any?, action: Selector) {
        self.title = title
        super.init(frame: .zero)
        button.addTarget(target, action: action, for: .touchUpInside)
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
}

extension PrimaryButtonView {
    
    fileprivate func setupViews() {
        addSubview(button)
        button.fill(view: self, margin: Margin.default)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 56)
        heightConstraint.priority = .required
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: deviceWidth),
            heightConstraint
        ])
    }
    
    fileprivate func updateUI() {
        button.setTitle(title, for: .normal)
    }
    
}
