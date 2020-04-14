//
//  GenericDataSource.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 10/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

typealias TableViewCell = UITableViewCell & ConfigurableCell & IdentifiableCell

class TableViewDataSourceDelegate<T: TableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias DataType = T.DataType
    typealias Selection = (DataType, Int) -> ()
    
    var data = [DataType]()
    var didSelect: Selection?

    init(data: [DataType], didSelect: Selection? = nil) {
        self.data = data
        self.didSelect = didSelect
    }
    
    func setup(tableView: UITableView) {
        tableView.register(T.self, forCellReuseIdentifier: T.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as! T
        cell.setup(data: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(data[indexPath.row], indexPath.row)
    }
    
}
