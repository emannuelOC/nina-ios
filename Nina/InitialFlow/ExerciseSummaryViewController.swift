//
//  ExerciseSummaryViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class ExerciseSummaryViewController: UIViewController {
    
    let minutes: Double
    let date: Date
    
    lazy var titleView: SimpleTitleView = SimpleTitleView(title: "Exercícios").notTranslating()
    
    lazy var textLabel: UILabel = {
        let label = UILabel().notTranslating()
        label.numberOfLines = 0
        return label
    }()
    
    init(minutes: Double, date: Date) {
        self.minutes = minutes
        self.date = date
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.secondary
        
        view.addSubview(titleView)
        view.addSubview(textLabel)
        
        titleView.attachToTop(at: view, margin: Margin.default)
        titleView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        titleView.titleLabel.textAlignment = .center
        
        textLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margin.default).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margin.default).isActive = true
        
        
        var suffix = "hoje."
        if !Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            suffix = "em \(formatter.string(from: date))."
        }
        let text = "Como você usa Apple Watch, é possível obter o seu tempo de exercícios pelo HealthKit."
            + " Você realizou \(minutes) minutos de exercício "
            + suffix
        
        textLabel.text = text
        
    }
    
}
