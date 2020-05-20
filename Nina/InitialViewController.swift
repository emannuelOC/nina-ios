//
//  InitialViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 09/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

enum InitialViewData {
    case button(String)
    case tree
}

class InitialViewController: UIViewController {
    
    var data: [InitialViewData] = ["Leitura", "Idiomas", "Habilidades", "Tree", "Exercícios", "Alimentação", "Sono"].map {
        if $0 == "Tree" {
            return InitialViewData.tree
        }
        return InitialViewData.button($0)
    }
    
    var viewModel: DayInformationViewModel?
    var healthManager: HealthManager?
    
    var isToday: Bool {
        let date = viewModel?.dailyResult.date ?? Date()
        return Calendar.current.isDateInToday(date)
    }
    
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
    }
    
    fileprivate func setupManager() {
        if !isToday {
            return
        }
        healthManager = HealthManager()
        healthManager?.retrieveExercises(completion: { [weak self] (minutes) in
            guard let self = self else { return }
            self.viewModel?.setScore(criteria: SoilCriteria.exercises, answer: .number(minutes))
            self.collectionView.reloadData()
        })
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.secondary
        collectionView.fill(view: view)
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
        if healthManager?.isAvailable ?? false {
            viewModel?.setScore(criteria: SoilCriteria.exercises,
                                answer: .number(healthManager?.exercises ?? 0.0))
        }
    }
    
}

extension InitialViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate func isDone(criteriaName: String) -> Bool {
        switch criteriaName {
        case "Leitura":
            return viewModel?.dailyResult.readingAdded ?? false
        case "Idiomas":
            return viewModel?.dailyResult.languagesAdded ?? false
        case "Habilidades":
            return viewModel?.dailyResult.skillsAdded ?? false
        case "Exercícios":
            return viewModel?.dailyResult.exercisesAdded ?? false
        case "Alimentação":
            return viewModel?.dailyResult.foodAdded ?? false
        case "Sono":
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
            cell.layer.cornerRadius = Radius.huge
            cell.layer.masksToBounds = true
            (cell as? TreeViewCell)?.treeView.branchesScore = viewModel?.branchesScore ?? 0
            (cell as? TreeViewCell)?.treeView.soilScore = viewModel?.soilScore ?? 0
            return cell
        case .button(let imageName):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InitialCollectionViewCell.self),
                                                          for: indexPath)

            cell.layer.masksToBounds = true
            (cell as? InitialCollectionViewCell)?.setup(data: imageName, done: isDone(criteriaName: imageName))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        switch item {
        case .tree:
            didTapTreeView()
        case .button(let name):
            if name == "Exercícios" && (healthManager?.isAvailable ?? false) {
                let vc = ExerciseSummaryViewController(minutes: viewModel?.dailyResult.exercisesScore ?? 0.0,
                                                       date: viewModel?.dailyResult.date ?? Date())
                vc.presentationController?.delegate = self
                present(vc, animated: true, completion: nil)
            } else if let criteria = BranchesCriteria.criteria(for: name) {
                didTapCriteria(criteria: criteria)
            } else if let criteria = SoilCriteria.criteria(for: name) {
                didTapCriteria(criteria: criteria)
            }
        }
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
