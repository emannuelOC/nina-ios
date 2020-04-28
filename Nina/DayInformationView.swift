//
//  DayInformationView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import HealthKit

struct Information {
    var title: String
    var question: String
    var options: [String: Answer]
}

protocol Criteria: CaseIterable {
    var information: Information { get }
    
    static func criteria(for string: String) -> Self?
    
    func validate(answer: Answer) -> Bool
}

let exercisesQuestion = "Você se exercitou por mais de 30 minutos hoje?"
let exercisesOptions = ["Sim": Answer.yesOrNo(true), "Não": Answer.yesOrNo(false)]
let foodQuestion = "Como você classificaria a sua alimentação hoje?"
let foodOptions: [String: Answer] = [
    "Muito saudável": .number(10),
    "Saudável": .number(7.5),
    "Regular": .number(5),
    "Não muito saudável": .number(2.5),
    "Nada saudável": .number(0)
]
let sleepQuestion = "Como você classificaria o seu sono hoje?"
let sleepOptions: [String: Answer] = [
    "Muito bom": .number(10),
    "Bom": .number(7.5),
    "Regular": .number(5),
    "Ruim": .number(2.5),
    "Péssimo": .number(0)
]

let readingQuestion = "Você leu algum livro ou artigo científico hoje?"
let readingOptions = ["Sim": Answer.yesOrNo(true), "Não": Answer.yesOrNo(false)]
let languageQuestion = "Você está estudando algum idioma estrangeiro? E fez alguma atividade nesse idioma hoje?"
let languageOptions: [String: Answer] = [
    "Estou estudando e realizei exercícios nesse idioma hoje": Answer.number(5),
    "Estou estudando mas não realizei exercícios nesse idioma hoje": Answer.number(3),
    "Não estou estudando nenhum idioma estrangeiro": Answer.number(1)
]
let skillsQuestion = "Você está aprendendo alguma habilidade nova?"
let skillsOptions: [String: Answer] = [
    "Sim": Answer.text(""),
    "Não": Answer.text("")
]

enum SoilCriteria: Criteria {
    case exercises, food, sleep
    
    static func criteria(for string: String) -> SoilCriteria? {
        return SoilCriteria.allCases.filter {
            $0.information.title == string
        }.first
    }
    
    var information: Information {
        switch self {
        case .exercises:
            return Information(title: "Exercícios", question: exercisesQuestion, options: exercisesOptions)
        case .food:
            return Information(title: "Alimentação", question: foodQuestion, options: foodOptions)
        case .sleep:
            return Information(title: "Sono", question: sleepQuestion, options: sleepOptions)
        }
    }
    
    func validate(answer: Answer) -> Bool {
        switch (self, answer) {
        case (.exercises, .number(let minutes)):
            return minutes >= 30
        case (_, .number(let quality)):
            return quality == 5
        default:
            return false
        }
    }
}

enum BranchesCriteria: Criteria {
    case reading, languages, skills
    
    static func criteria(for string: String) -> BranchesCriteria? {
        return BranchesCriteria.allCases.filter {
            $0.information.title == string
        }.first
    }
    
    var information: Information {
        switch self {
        case .reading:
            return Information(title: "Leitura", question: readingQuestion, options: readingOptions)
        case .languages:
            return Information(title: "Idiomas", question: languageQuestion, options: languageOptions)
        case .skills:
            return Information(title: "Habilidades", question: skillsQuestion, options: skillsOptions)
        }
    }
    
    func validate(answer: Answer) -> Bool {
        switch (self, answer) {
        case (.skills, .text(let skill)):
            return !skill.isEmpty
        case (_, .yesOrNo(let done)):
            return done
        default:
            return false
        }
    }
}

protocol DayInformationViewDelegate: class {
    func dayInformationView<T: Criteria>(_ dayInformationView: DayInformationView,
                            didSelect criteria: T)
}

class DayInformationView: UIView {
    
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
        backgroundColor = .white
        
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
        if let criteria = SoilCriteria.criteria(for: choice) {
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
