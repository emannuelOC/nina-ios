//
//  SelectionTableViewCell.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

struct SelectionData {
    var title: String
    var state: CheckView.State
}

class SelectionTableViewCell: UITableViewCell {
    
    lazy var checkView = CheckView(title: "").notTranslating()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectionTableViewCell {
    fileprivate func setupViews() {
        checkView.fill(view: contentView)
        backgroundColor = Color.secondary
        contentView.backgroundColor = Color.secondary
        textLabel?.numberOfLines = 0
    }
}

extension SelectionTableViewCell: ConfigurableCell, IdentifiableCell {
    typealias DataType = SelectionData
    
    func setup(data: SelectionData) {
        checkView.title = data.title
        checkView.state = data.state
    }
}
