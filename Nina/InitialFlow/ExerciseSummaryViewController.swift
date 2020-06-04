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
    
    lazy var titleView: SimpleTitleView = {
        let text = NSLocalizedString("Exercises", comment: "Physical activities")
        let titleView = SimpleTitleView(title: text).notTranslating()
        return titleView
    }()
    
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
        titleView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        titleView.titleLabel.textAlignment = .center
        
        textLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margin.default).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margin.default).isActive = true
        
        
        var suffix = NSLocalizedString("today.", comment: "")
        if !Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            suffix = NSLocalizedString("at", comment: "as in: `at June 3rd`") + " \(formatter.string(from: date))."
        }
        let text = NSLocalizedString("watch.exercise.text", comment: "Explain where data comes from")
        let minutesString = String(format: "%.2f", minutes)
        let localizedText = String(format: text, minutesString) + " \(suffix)"
        
        textLabel.text = localizedText
        
    }
    
}
