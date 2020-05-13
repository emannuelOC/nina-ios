//
//  GenericCell.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func setup(data: DataType)
}

protocol IdentifiableCell {
    static var cellIdentifier: String { get }
}

extension IdentifiableCell {
    static var cellIdentifier: String {
        return "\(self)"
    }
}

class SimpleTableViewCell: UITableViewCell {
    
}

extension SimpleTableViewCell: ConfigurableCell, IdentifiableCell {
    
    typealias DataType = String
    
    func setup(data: String) {
        textLabel?.text = data
    }
    
}
