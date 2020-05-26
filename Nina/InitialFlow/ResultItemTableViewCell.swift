//
//  ResultItemTableViewCell.swift
//  Nina
//
//  Created by Emannuel Carvalho on 28/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class ResultItemTableViewCell: UITableViewCell, IdentifiableCell, ConfigurableCell {
    
    typealias DataType = DailyResult
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    func setup(data: DataType) {
        backgroundColor = Color.secondary
        contentView.backgroundColor = Color.secondary
        textLabel?.textColor = Color.primary
        textLabel?.text = formatter.string(from: data.date ?? Date())
    }
    
}
