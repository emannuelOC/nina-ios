//
//  SelectionView.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

protocol SelectionViewDelegate: class {
    func selectionView(_ selectionView: SelectionView, didSelect choice: String)
}

class SelectionView: UIView {
    
    var choices: [String] {
        didSet {
            updateUI()
        }
    }
    
    var selectedIndices = [Int]() {
        didSet {
            updateUI()
        }
    }
    
    var title: String?
    
    var isExpanded: Bool
    
    var heightConstraint: NSLayoutConstraint?
    
    weak var delegate: SelectionViewDelegate?
    
    var dataSource: TableViewDataSourceDelegate<SelectionTableViewCell>?
    
    var allowsMultipleSelection = false
    
    var tableView: UITableView = {
        let tableView = ContentSizedTableView().notTranslating()
        tableView.bounces = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(choices: [String],
         allowsMultipleSelection: Bool = false,
         delegate: SelectionViewDelegate? = nil,
         expanded: Bool = true) {
        self.choices = choices
        self.allowsMultipleSelection = allowsMultipleSelection
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
        selectedIndices = []
        tableView.reloadData()
    }
    
    func disselect(choice: String) {
        if let index = choices.enumerated().filter({ $0.element == choice }).first?.offset {
            remove(index: index)
        }
    }
    
    func select(choice: String) {
        if let index = choices.enumerated().filter({ $0.element == choice }).first?.offset {
            include(index: index)
        }
    }
    
    fileprivate func include(index: Int) {
        if allowsMultipleSelection {
            selectedIndices.append(index)
        } else {
            selectedIndices = [index]
        }
    }
    
    fileprivate func remove(index: Int) {
        selectedIndices = selectedIndices.filter { $0 != index }
    }
    
    fileprivate func setupViews() {
        tableView.fill(view: self)
        if isExpanded {
            widthAnchor.constraint(equalToConstant: deviceWidth).isActive = true
        }
    }
    
    fileprivate func updateUI() {
        dataSource?.data = generateData()
        tableView.reloadData()
    }
    
    fileprivate func setupDataSource() {
        let data = generateData()
        dataSource = TableViewDataSourceDelegate<SelectionTableViewCell>(data: data) { [weak self] (choice, index) in
            guard let `self` = self else { return }
            if self.selectedIndices.contains(index) {
                self.selectedIndices = self.selectedIndices.filter { $0 != index }
            } else {
                self.include(index: index)
            }
            self.delegate?.selectionView(self, didSelect: choice.title)
        }
        dataSource?.setup(tableView: tableView)
    }
    
    fileprivate func generateData() -> [SelectionData] {
        if selectedIndices.isEmpty {
            return choices.map { SelectionData(title: $0, state: .available) }
        }
        
        return choices.enumerated().map { (index, choice) in
            let alternative = allowsMultipleSelection ? CheckView.State.available : CheckView.State.unselected
            return SelectionData(title: choice,
                                 state: selectedIndices.contains(index) ? .selected : alternative)
        }
    }
}
