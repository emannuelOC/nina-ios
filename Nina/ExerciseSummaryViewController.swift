//
//  ExerciseSummaryViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import HealthKit

class ExerciseSummaryViewController: UIViewController {
    
    let summary: HKActivitySummary
    let date: Date
    
    init(summary: HKActivitySummary, date: Date) {
        self.summary = summary
        self.date = date
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.secondary
        var suffix = "hoje."
        if !Calendar.current.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            suffix = "no dia \(formatter.string(from: date))."
        }
        let text = "Como você usa Apple Watch, é possível calcular obter os seus exercícios pelo HealthKit."
            + " Você realizou \(self.summary.appleExerciseTime.doubleValue(for: .minute())) minutos de exercício "
            + suffix
        view.fill(with: [
            SimpleTitleView(title: "Exercícios"),
            SimpleTextView(text: text)
        ])
    }
    
}
