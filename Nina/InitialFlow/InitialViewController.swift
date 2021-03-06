//
//  InitialViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 09/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

enum InitialViewData {
    case button(String, String)
    case tree
}

class InitialViewController: UIViewController {
    
    var data: [InitialViewData] = [
        ("Leitura", NSLocalizedString("Reading", comment: "The act of reading")),
        ("Idiomas", NSLocalizedString("Languages", comment: "")),
        ("Habilidades", NSLocalizedString("Skills", comment: "")),
        ("", "Tree"),
        ("Exercícios", NSLocalizedString("Exercises", comment: "Physical activities")),
        ("Alimentação", NSLocalizedString("Food", comment: "")),
        ("Sono", NSLocalizedString("Sleep", comment: "The noun"))].map {
            if $0.1 == "Tree" {
                return InitialViewData.tree
        }
            return InitialViewData.button($0.0, $0.1)
    }
    
    var viewModel: DayInformationViewModel?
    var healthManager: HealthManager?
    
    var isToday: Bool {
        let date = viewModel?.dailyResult.date ?? Date()
        return Calendar.current.isDateInToday(date)
    }
    
    var isExercisesAvailable: Bool?
    
    var previousResult: DailyResult?
    
    lazy var collectionView: UICollectionView = {
        let layout = InitialColectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Color.secondary
        collectionView.register(InitialCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: InitialCollectionViewCell.self))
        collectionView.register(TreeViewCell.self,
                                forCellWithReuseIdentifier: String(describing: TreeViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(result: DailyResult? = nil) {
        self.previousResult = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManager()
        setupViews()
        setupViewModel()
        updateExercises()
        setupTitle()
    }
    
    fileprivate func setupManager() {
        if !isToday {
            return
        }
        healthManager = HealthManager()
        healthManager?.retrieveExercises(completion: { [weak self] (minutes) in
            guard let minutes = minutes else {
                    self?.isExercisesAvailable = false
                    return
            }
            self?.isExercisesAvailable = true
            self?.viewModel?.setScore(criteria: SoilCriteria.exercises, answer: .number(minutes / 3))
            self?.collectionView.reloadData()
        })
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.secondary
        collectionView.fill(view: view)
    }
    
    fileprivate func setupTitle() {
        if isToday {
            title = NSLocalizedString("Today", comment: "")
            return
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        title = formatter.string(from: viewModel?.dailyResult.date ?? Date())
    }
    
    fileprivate func setupViewModel() {
        if let context = view.context {
            guard let result = previousResult else {
                viewModel = DayInformationViewModel(context: context)
                return
            }
            viewModel = DayInformationViewModel(context: context, result: result)
        }
    }
    
    fileprivate func updateExercises() {
        if !isToday {
            return
        }
        if let score = healthManager?.exercises,
            healthManager?.isAvailable ?? false {
            viewModel?.setScore(criteria: SoilCriteria.exercises,
                                answer: .number(score))
        }
    }
    
}

extension InitialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate func isDone(criteriaName: String) -> Bool {
        switch criteriaName {
        case NSLocalizedString("Reading", comment: "The act of reading"):
            return viewModel?.dailyResult.readingAdded ?? false
        case NSLocalizedString("Languages", comment: ""):
            return viewModel?.dailyResult.languagesAdded ?? false
        case NSLocalizedString("Skills", comment: ""):
            return viewModel?.dailyResult.skillsAdded ?? false
        case NSLocalizedString("Exercises", comment: "Physical activities"):
            return viewModel?.dailyResult.exercisesAdded ?? false
        case NSLocalizedString("Food", comment: ""):
            return viewModel?.dailyResult.foodAdded ?? false
        case NSLocalizedString("Sleep", comment: "The noun"):
            return viewModel?.dailyResult.sleepAdded ?? false
        default:
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch data[indexPath.item] {
        case .tree:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TreeViewCell.self),
                                                          for: indexPath)
            cell.layer.cornerRadius = 100
            cell.layer.masksToBounds = true
            (cell as? TreeViewCell)?.treeView.branchesScore = viewModel?.branchesScore ?? 0
            (cell as? TreeViewCell)?.treeView.soilScore = viewModel?.soilScore ?? 0
            return cell
        case .button(let imageName, let text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InitialCollectionViewCell.self),
                                                          for: indexPath)

            cell.layer.masksToBounds = true
            (cell as? InitialCollectionViewCell)?.setup(imageName: imageName, text: text, done: isDone(criteriaName: text))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        switch item {
        case .tree:
            didTapTreeView()
        case .button(_, let name):
            if name == NSLocalizedString("Exercises", comment: "Physical activities") {
               presentExercises()
            } else if let criteria = BranchesCriteria.criteria(for: name) {
                didTapCriteria(criteria: criteria)
            } else if let criteria = SoilCriteria.criteria(for: name) {
                didTapCriteria(criteria: criteria)
            }
        }
    }
    
    fileprivate func presentExercises() {
        if let isAvailable = isExercisesAvailable {
            if isAvailable {
                presentWatchExercises(score: viewModel?.dailyResult.exercisesScore ?? 0.0)
            } else {
                presentUserInputExercises()
            }
        } else {
            healthManager?.retrieveExercises(completion: { (score) in
                guard let score = score else {
                    self.presentUserInputExercises()
                    return
                }
                self.presentWatchExercises(score: score)
            })
        }
    }
    
    fileprivate func presentUserInputExercises() {
        self.didTapCriteria(criteria: SoilCriteria.exercises)
    }
    
    fileprivate func presentWatchExercises(score: Double) {
        let vc = ExerciseSummaryViewController(minutes: score * 3,
                                               date: viewModel?.dailyResult.date ?? Date())
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

extension InitialViewController {
    
    fileprivate func didTapTreeView() {
        let vc = TreeViewController()
        vc.branchesScore = viewModel?.branchesScore ?? 0.0
        vc.soilScore = viewModel?.soilScore ?? 0.0
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func didTapCriteria<T: Criteria>(criteria: T) {
        if !isToday {
            return
        }
        let vc = CriteriaViewController(criteria: criteria)
        vc.delegate = self
        vc.presentationController?.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension InitialViewController: CriteriaViewControllerDelegate {
    
    
    func criteriaViewController<T>(_ viewController: CriteriaViewController<T>,
                                   didAdd answer: Answer,
                                   to criteria: T) where T : Criteria {
        viewModel?.setScore(criteria: criteria, answer: answer)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension InitialViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        collectionView.reloadData()
    }
    
}
