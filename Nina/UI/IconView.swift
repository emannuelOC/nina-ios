//
//  IconView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 09/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    var image: UIImage?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: image).notTranslating()
        return imageView
    }()
    
    init(image: UIImage?) {
        self.image = image
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IconView {
    
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.constraintSquare(side: 24)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margin.default).isActive = true
    }
    
}
