//
//  InitialCollectionViewCell.swift
//  Nina
//
//  Created by Emannuel Carvalho on 12/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class InitialCollectionViewCell: UICollectionViewCell {
    
    enum GradientType {
        case branches, soil
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView().notTranslating()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let gradientLayer = CAGradientLayer()
    let borderLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    
    func setup(data: String, type: GradientType, value: Double) {
        imageView.image = UIImage(named: data)
        setupLayer(type: type)
        var color = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        if type == .soil {
            color = #colorLiteral(red: 0.8117647059, green: 0.3483233194, blue: 0.4883898002, alpha: 1)
        }
        setupProgress(value: value, color: color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        imageView.fill(view: contentView, margin: 30)
        setupBorderLayer()
    }
    
    fileprivate func setupLayer(type: GradientType) {
        let inset = CGFloat(18)
        gradientLayer.frame = bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        gradientLayer.cornerRadius = gradientLayer.frame.width / 2
        if gradientLayer.superlayer == nil {
            contentView.layer.insertSublayer(gradientLayer, at: 0)
        }
        switch type {
        case .branches:
            gradientLayer.colors = [#colorLiteral(red: 0.2257917876, green: 0.1092537814, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)].map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .soil:
            gradientLayer.colors = [#colorLiteral(red: 0.8117647059, green: 0.3483233194, blue: 0.4883898002, alpha: 1), #colorLiteral(red: 0.9803921569, green: 1, blue: 0.5019607843, alpha: 0.75)].map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: -1.3, y: -1.3)
        }
    }
    
    fileprivate func setupProgress(value: Double, color: UIColor) {
        let path = UIBezierPath(ovalIn: bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = color.cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.path = path.cgPath
        if progressLayer.superlayer == nil {
            contentView.layer.addSublayer(progressLayer)
        }
    }
    
    fileprivate func setupBorderLayer() {
        let path = UIBezierPath(ovalIn: bounds.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = Color.secondary.cgColor
        borderLayer.lineWidth = 6
        borderLayer.strokeEnd = 1
        borderLayer.path = path.cgPath
        contentView.layer.addSublayer(borderLayer)
    }
    
}

