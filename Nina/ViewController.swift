//
//  ViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.fill(with: [
            SimpleTitleView(title: "Hello World"),
            ShortTextInputView(placeholder: "hello world"),
            OptionsInputView(options: ["Hello", "World"]),
            LongTextInputView(),
            QuestionView(question: "Hello?")
        ])
        
        view.backgroundColor = Color.secondary
    }


}

