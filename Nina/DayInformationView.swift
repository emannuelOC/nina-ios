//
//  DayInformationView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import HealthKit

protocol DayInformationViewDelegate: class {
    func dayInformationView<T: Criteria>(_ dayInformationView: DayInformationView,
                            didSelect criteria: T)
    func dayInformationView(_ dayInformationView: DayInformationView,
                            didSelect exerciseSummary: HKActivitySummary)
}

class DayInformationView: UIView {
    
    lazy var treeView = TreeView().notTranslating()
    
    lazy var soilView = SelectionView(choices: soilButtons, allowsMultipleSelection: true, delegate: self).notTranslating()
    lazy var branchesView = SelectionView(choices: branchButtons, allowsMultipleSelection: true, delegate: self).notTranslating()
    
    let soilButtons = SoilCriteria.allCases.map { $0.information.title }
    let branchButtons = BranchesCriteria.allCases.map { $0.information.title }
    
    var summary: HKActivitySummary? {
        didSet {
            setupExercises()
            updateUI()
        }
    }
    
    var branchInformations = [BranchesCriteria: Answer]()
    var soilInformations = [SoilCriteria: Answer]()
    
    var isInteractive: Bool
    
    var viewModel: DayInformationViewModel?
    
    weak var delegate: DayInformationViewDelegate?
    
    var healthKitAvailable = false {
        didSet {
            setupExercises()
        }
    }
    
    init(isInteractive: Bool = true) {
        self.isInteractive = isInteractive
        super.init(frame: .zero)
        if let context = context {
            viewModel = DayInformationViewModel(context: context)
            branchInformations = viewModel?.dailyResult.branchInformations ?? [:]
            soilInformations = viewModel?.dailyResult.soilInformations ?? [:]
        }
        setupViews()
        authorizeHealthKit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DayInformationView {
    
    func set<T: Criteria>(answer: Answer, for criteria: T) {
        viewModel?.setScore(criteria: criteria, answer: answer)
        if let criteria = criteria as? BranchesCriteria {
            branchInformations[criteria] = answer
            
        }
        
        if let criteria = criteria as? SoilCriteria {
            soilInformations[criteria] = answer
        }
        
    }
    
    func updateUI() {
        setupSoilInformations()
        setupBranchesInformations()
    }
    
    fileprivate func setupViews() {
        backgroundColor = Color.secondary
        
        fill(with: [
            SimpleTitleView(title: "Cuidando do solo:"),
            soilView,
            SimpleTitleView(title: "Cuidando dos ramos:"),
            branchesView,
            SimpleTextView(text: "")
        ])
    }
    
    fileprivate func showBranchesSelection(for choice: String) {
        if let criteria = BranchesCriteria.criteria(for: choice) {
            showSelection(for: criteria)
        }
    }
    
    fileprivate func showSoilSelection(for choice: String) {
        if choice == "Exercícios",
            let summary = summary {
            delegate?.dayInformationView(self, didSelect: summary)

        } else if let criteria = SoilCriteria.criteria(for: choice) {
            showSelection(for: criteria)
        }
    }
    
    fileprivate func showSelection<T: Criteria>(for criteria: T) {
        delegate?.dayInformationView(self, didSelect: criteria)
    }
    
    fileprivate func authorizeHealthKit() {
        guard HKHealthStore.isHealthDataAvailable() else {
            healthKitAvailable = false
            return
        }
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.activitySummaryType(),
            HKObjectType.workoutType()
        ]
                
        HKHealthStore()
            .requestAuthorization(toShare: Set<HKSampleType>(), read: healthKitTypesToRead) { (authorized, error) in
                DispatchQueue.main.async {
                    self.healthKitAvailable = authorized
                }
        }
        
        
        let query = HKActivitySummaryQuery(predicate: nil) { (query, summaries, error) in
            DispatchQueue.main.async {
                self.summary = summaries?.last
            }
        }
        HKHealthStore().execute(query)
    }
    
    fileprivate func setupExercises() {
        let exerciseMinutes = (self.summary?.appleExerciseTime.doubleValue(for: .minute()) ?? 0)
        soilInformations[.exercises] = Answer.number(Double(exerciseMinutes))
    }
    
    fileprivate func setupBranchesInformations() {
        for criteria in BranchesCriteria.allCases {
            if branchInformations[criteria] != nil{
                branchesView.select(choice: criteria.information.title)
            } else {
                branchesView.disselect(choice: criteria.information.title)
            }
        }
    }
    
    fileprivate func setupSoilInformations() {
        for criteria in SoilCriteria.allCases {
            if soilInformations[criteria] != nil {
                soilView.select(choice: criteria.information.title)
            } else {
                soilView.disselect(choice: criteria.information.title)
            }
        }
    }
    
}

extension DayInformationView: SelectionViewDelegate {
    
    func selectionView(_ selectionView: SelectionView, didSelect choice: String) {
        if !isInteractive {
            return
        }
        if selectionView == soilView {
            showSoilSelection(for: choice)
        } else {
            showBranchesSelection(for: choice)
        }
    }
    
}
