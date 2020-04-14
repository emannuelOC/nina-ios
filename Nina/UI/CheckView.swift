//
//  CheckView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 09/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class CheckView: UIView {
    
    enum State {
        case available, selected, unselected
    }
    
    var title: String {
        didSet {
            updateUI()
        }
    }
    
    var state: State {
        didSet {
            updateUI()
        }
    }
    
    var bordered: Bool {
        didSet {
            updateUI()
        }
    }
    
    lazy var titleView: SimpleTextView = {
        let view = SimpleTextView(text: title).notTranslating()
        return view
    }()
    
    lazy var checkIconView: IconView = {
        let imageView = IconView(image: Images.check).notTranslating()
        return imageView
    }()
    
    lazy var borderView: UIView = {
        let view = UIView().notTranslating().backgrounded(color: Color.terciary)
        return view
    }()
    
    init(title: String, state: State = .available, bordered: Bool = true) {
        self.title = title
        self.state = state
        self.bordered = bordered
        super.init(frame: .zero)
        setupViews()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckView {
    
    fileprivate func updateUI() {
        titleView.state = state == .unselected ? .disabled : .enabled
        titleView.text = title
        checkIconView.isHidden = state != .selected
    }
    
    fileprivate func setupViews() {
        fill(with: [titleView, checkIconView], axis: .horizontal)
        addSubview(borderView)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        checkIconView.constraintSquare(side: 56)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 56),
            borderView.heightAnchor.constraint(equalToConstant: 1),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margin.default),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margin.default),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
