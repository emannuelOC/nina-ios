//
//  InitialViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import HealthKit

class DailyResultViewController: UIViewController {
    
    var result: DailyResult?

    lazy var dayInformationView: DayInformationView = {
        let isInteractive = Calendar.current.isDateInToday((result?.date ?? Date()))
        let dayInformationView = DayInformationView(isInteractive: isInteractive)
        if let result = result {
            dayInformationView.branchInformations = result.branchInformations
            dayInformationView.soilInformations = result.soilInformations
        }
        return dayInformationView
    }()
    
    init(result: DailyResult? = nil) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = dayInformationView
        view.delegate = self
        self.view = view
        setupTitle()
    }
    
    fileprivate func setupTitle() {
        let date = result?.date ?? Date()
        if Calendar.current.isDateInToday(date) {
            title = "Hoje"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            title = formatter.string(from: date)
        }
    }
    
}

extension DailyResultViewController: DayInformationViewDelegate {
    
    func dayInformationView<T>(_ dayInformationView: DayInformationView, didSelect criteria: T) where T : Criteria {
        let vc = CriteriaViewController(criteria: criteria)
        vc.delegate = self
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func dayInformationView(_ dayInformationView: DayInformationView, didSelect exerciseSummary: HKActivitySummary) {
        let vc = ExerciseSummaryViewController(summary: exerciseSummary,
                                               date: dayInformationView.viewModel?.dailyResult.date ?? Date())
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

extension DailyResultViewController: CriteriaViewControllerDelegate {
    
    func criteriaViewController<T>(_ viewController: CriteriaViewController<T>,
                                   didAdd answer: Answer,
                                   to criteria: T) where T : Criteria {
        dayInformationView.set(answer: answer, for: criteria)
        dayInformationView.updateUI()
        dismiss(animated: true, completion: nil)
    }
    
}

extension DailyResultViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dayInformationView.updateUI()
    }
    
}
