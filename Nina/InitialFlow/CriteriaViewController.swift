//
//  CriteriaViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

enum Answer {
    case yesOrNo(Bool)
    case text(String)
    case number(Double)
}

extension Answer: Comparable {
    
    static func < (lhs: Answer, rhs: Answer) -> Bool {
        switch (lhs, rhs) {
        case let (.yesOrNo(l), .yesOrNo(r)):
            return l || !r
        case let (.number(l), .number(r)):
            return l > r
        default:
            return true
        }
    }
    
}

protocol CriteriaViewControllerDelegate: class {
    func criteriaViewController<T: Criteria>(_ viewController: CriteriaViewController<T>,
                                didAdd answer: Answer,
                                to criteria: T)
}

class CriteriaViewController<T: Criteria>: UIViewController, SelectionViewDelegate {
    
    var criteria: T
    
    var delegate: CriteriaViewControllerDelegate?
    
    var selectedAnswer: Answer?
    
    lazy var doneButtonView: PrimaryButtonView = {
        let text = NSLocalizedString("Confirm", comment: "")
        let buttonView = PrimaryButtonView(title: text, target: self, action: #selector(confirm)).notTranslating()
        return buttonView
    }()
    
    init(criteria: T) {
        self.criteria = criteria
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.secondary
        
        let options = criteria.information.options.keys.sorted { (lhs, rhs) -> Bool in
            let options = criteria.information.options
            guard let option1 = options[lhs],
                let option2 = options[rhs] else {
                    return false
            }
            return option1 < option2
        }
        
        view.fill(with: [
            SimpleTitleView(title: criteria.information.title),
            SimpleTextView(text: criteria.information.question),
            SelectionView(choices: Array(options),
                          allowsMultipleSelection: false,
                          delegate: self,
                          expanded: true)
        ])
        
        doneButtonView.attachToBottom(at: view)
    }
    
    @objc fileprivate func confirm() {
        if let answer = selectedAnswer {
            delegate?.criteriaViewController(self, didAdd: answer, to: criteria)
        }
    }
    
    func selectionView(_ selectionView: SelectionView, didSelect choice: String) {
        selectedAnswer = criteria.information.options[choice]
    }
    
}
