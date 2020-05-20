//
//  GradientView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 13/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    var colors: [UIColor] = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var startPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var endPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let gradientLayer = CAGradientLayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }

    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = self.colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
}

class GradientButton: UIButton {
    
    var colors: [UIColor] = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var startPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var endPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let gradientLayer = CAGradientLayer()
    let shadowLayer = CALayer()

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }

    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = self.colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
}
