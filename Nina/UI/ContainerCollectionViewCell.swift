//
//  ContainerCollectionViewCell.swift
//  Nina
//
//  Created by Emannuel Carvalho on 12/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

public final class ContainerCollectionViewCell<V: UIView>: UICollectionViewCell {

    public lazy var view: V = {
        return V()
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
