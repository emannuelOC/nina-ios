//
//  SelectionView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

protocol SelectionViewDelegate: class {
    func selectionView(_ selectionView: SelectionView, didSelect choice: String)
}

class SelectionView: UIView {
    
    var choices: [String] {
        didSet {
            updateUI()
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            updateUI()
        }
    }
    
    var title: String?
    
    var isExpanded: Bool
    
    var heightConstraint: NSLayoutConstraint?
    
    weak var delegate: SelectionViewDelegate?
    
    var dataSource: TableViewDataSourceDelegate<SelectionTableViewCell>?
    
    var tableView: UITableView = {
        let tableView = UITableView().notTranslating()
        tableView.bounces = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(choices: [String], delegate: SelectionViewDelegate? = nil, expanded: Bool = true) {
        self.choices = choices
        self.delegate = delegate
        self.isExpanded = expanded
        super.init(frame: .zero)
        setupViews()
        setupDataSource()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectionView {
    
    func disselect() {
        selectedIndex = nil
        tableView.reloadData()
    }
    
    fileprivate func setupViews() {
        tableView.fill(view: self)
        if isExpanded {
            widthAnchor.constraint(equalToConstant: deviceWidth).isActive = true
            heightConstraint = heightAnchor.constraint(equalToConstant: CGFloat(choices.count) * 56)
            heightConstraint?.isActive = true
        }
    }
    
    fileprivate func updateUI() {
        dataSource?.data = generateData()
        tableView.reloadData()
        heightConstraint?.constant = CGFloat(choices.count) * 56
    }
    
    fileprivate func setupDataSource() {
        let data = generateData()
        dataSource = TableViewDataSourceDelegate<SelectionTableViewCell>(data: data) { [weak self] (choice, index) in
            guard let `self` = self else { return }
            self.selectedIndex = index
            self.delegate?.selectionView(self, didSelect: choice.title)
        }
        dataSource?.setup(tableView: tableView)
    }
    
    fileprivate func generateData() -> [SelectionData] {
        if selectedIndex == nil {
            return choices.map { SelectionData(title: $0, state: .available) }
        }
        
        return choices.enumerated().map { (index, choice) in
            SelectionData(title: choice,
                          state: index == (selectedIndex ?? -1) ? .selected : .unselected)
        }
    }
}
