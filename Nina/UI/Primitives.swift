//
//  Primitives.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 09/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

struct Margin {
    static let `default` = CGFloat(20)
    static let big = CGFloat(60)
}

struct Color {
    static let primary = UIColor(hex: "#000000") ?? .black
    static let secondary = UIColor(hex: "#FFFFFF") ?? .black
    static let terciary = UIColor(hex: "#F4F7FB") ?? .gray
}

struct Font {
    static let regular = UIFont(name: "Helvetica", size: 20)
    static let bold = UIFont(name: "Helvetica Bold", size: 20)
}

struct Radius {
    static let normal = CGFloat(4)
}

struct Images {
    static let check = UIImage(named: "check")
    static let arrowDown = UIImage(named: "arrow-down")
}

class Label: UILabel {
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        font = Font.regular
    }
    
}

class BoldLabel: Label {
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        font = Font.bold
    }
    
}
