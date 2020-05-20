//
//  RegularNavigationController.swift
//  Lana
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class RegularNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupAppearance()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAppearance() {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.primaryButton,
            NSAttributedString.Key.font: Font.regular
        ]
        
        navigationBar.tintColor = Color.primaryButton
        navigationBar.barTintColor = Color.secondary
        navigationBar.backgroundColor = Color.secondary
        navigationBar.isTranslucent = false
    }
    
}
