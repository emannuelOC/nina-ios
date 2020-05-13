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
    
    lazy var collectionView: UICollectionView = {
        let layout = InitialColectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Color.white
        collectionView.register(InitialCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: InitialCollectionViewCell.self))
        collectionView.register(TreeViewCell.self,
                                forCellWithReuseIdentifier: String(describing: TreeViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupManager()
        setupViews()
        setupViewModel()
        updateExercises()
    }
    
    fileprivate func setupManager() {
        healthManager = HealthManager()
        healthManager?.retrieveExercises(completion: { [weak self] (minutes) in
            guard let self = self else { return }
            self.viewModel?.setScore(criteria: SoilCriteria.exercises, answer: .number(minutes))
            self.collectionView.reloadData()
        })
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = Color.white
        collectionView.fill(view: view)
    }
    
    fileprivate func setupViewModel() {
        if let context = view.context {
            viewModel = DayInformationViewModel(context: context)
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
    
    fileprivate func score(for criteriaName: String) -> Double {
        switch criteriaName {
        case "Leitura":
            return viewModel?.dailyResult.readingScore ?? 0.0
        case "Idiomas":
            return viewModel?.dailyResult.languagesScore ?? 0.0
        case "Habilidades":
            return viewModel?.dailyResult.skillsScore ?? 0.0
        case "Exercícios":
            return viewModel?.dailyResult.exercisesScore ?? 0.0
        case "Alimentação":
            return viewModel?.dailyResult.foodScore ?? 0.0
        case "Sono":
            return viewModel?.dailyResult.sleepScore ?? 0.0
        default:
            return 0.0
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
        case .button(let imageName):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InitialCollectionViewCell.self),
                                                          for: indexPath)
            cell.layer.cornerRadius = 50
            cell.layer.masksToBounds = true
            (cell as? InitialCollectionViewCell)?.setup(data: imageName,
                                                        type: indexPath.item > 3 ? .soil : .branches,
                                                        value: score(for: imageName) / 10)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        switch item {
        case .tree:
            didTapTreeView()
        case .button(let name):
            if let criteria = BranchesCriteria.criteria(for: name) {
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
