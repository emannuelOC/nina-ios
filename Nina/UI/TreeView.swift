//
//  TreeView.swift
//  Nina
//
//  Created by Emannuel Carvalho on 02/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit

extension CGFloat {
    var toRadians: CGFloat {
        return self * .pi / 180
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: minX + width / 2,
                       y: minY + height / 2)
    }
    
    func multiplied(by point: CGPoint) -> CGRect {
        let width = self.width * point.x
        let height = self.height * point.y
        let deltaX = self.width - width
        let deltaY = self.height - height
        return CGRect(x: minX + deltaX / 2,
                      y: minY + deltaY / 2,
                      width: width,
                      height: height)
    }
    
    func translated(by point: CGPoint) -> CGRect {
        return CGRect(x: minX * 1 + point.x,
                      y: minY * 1 + point.y,
                      width: width,
                      height: height)
    }
}

// 32 76 85

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(displayP3Red: r / 255.0,
                       green: g / 255.0,
                       blue: b / 255.0,
                       alpha: a)
    }
    
}

class TreeView: UIView {
    
    var branchesScore = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    var soilScore = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    fileprivate var treeRect: CGRect {
        return bounds//phySmallerRect(than: bounds)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawTree()
    }
    
    fileprivate func updateUI() {
        for layer in self.layer.sublayers ?? [] {
            layer.removeFromSuperlayer()
        }
        drawTree()
    }

    fileprivate func phySmallerRect(than rect: CGRect) -> CGRect {
        let width = rect.width / 1.618
        let height = rect.height / 1.618
        let deltaX = rect.width - width
        let deltaY = rect.height - height
        return CGRect(x: rect.minX + deltaX / 2,
                      y: rect.minY + deltaY / 2,
                      width: width,
                      height: height)
    }
    
    fileprivate func drawTree() {
        addTrunkLayer()
        addSoilLayer()
        addLeavesLayer()
    }
    
    fileprivate var leafColors: [UIColor] {
        let startColors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.4678211517, green: 0.671089179, blue: 0.7550437236, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
        
        let endColors = [#colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), #colorLiteral(red: 0.3125552973, green: 0.4637626598, blue: 0.5608444037, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
        
        return [
            startColors[Int(branchesScore/5.0)],
            endColors[Int(branchesScore/5.0)]
        ]
    }
    
    fileprivate var soilColors: [UIColor] {
        let startColors = [#colorLiteral(red: 0.4207496841, green: 0.4622125972, blue: 0.378383644, alpha: 0.75), #colorLiteral(red: 0.5447498381, green: 0.4133276306, blue: 0.3033174181, alpha: 0.75), #colorLiteral(red: 0.783759715, green: 0.5946758004, blue: 0.4363984283, alpha: 0.75), #colorLiteral(red: 0.9803921569, green: 1, blue: 0.5019607843, alpha: 0.75)]
        let endColors = [#colorLiteral(red: 0.0594765504, green: 0.1717940415, blue: 0.09232076838, alpha: 1), #colorLiteral(red: 0.3591726036, green: 0.2725486673, blue: 0.2004464378, alpha: 1), #colorLiteral(red: 0.5823348445, green: 0.4418894543, blue: 0.3249884429, alpha: 1), #colorLiteral(red: 0.8117647059, green: 0.4588235294, blue: 0.262745098, alpha: 1)]
        
        return [
            startColors[Int(soilScore/3.0)],
            endColors[Int(soilScore/3.0)]
        ]
    }
    
    fileprivate func addTrunkLayer() {
        
        let layer = CAShapeLayer()
        layer.frame = self.layer.bounds
        let trunkRect = treeRect
            .multiplied(by: CGPoint(x: 0.09, y: 0.15))
            .translated(by: CGPoint(x: 0, y: 2))
        let path = UIBezierPath(roundedRect: trunkRect,
                                cornerRadius: bounds.width * 0.01)
        
        let color = UIColor.rgb(r: 32, g: 76, b: 85)
        
        layer.path = path.cgPath
        layer.fillColor = color.cgColor
        
        self.layer.addSublayer(layer)
    }
    
    fileprivate func addSoilLayer() {
        let layer = CAShapeLayer()
        layer.frame = self.layer.bounds
        
        let soilRect = treeRect.multiplied(by: CGPoint(x: 0.531, y: 0.531))
        
        let soilPath = UIBezierPath(arcCenter: bounds.center,
                                    radius: soilRect.width / 2,
                                    startAngle: CGFloat(5).toRadians,
                                    endAngle: CGFloat(175).toRadians,
                                    clockwise: true)
        soilPath.close()
        layer.path = soilPath.cgPath
        
        
        let soilLayer = createGradientLayer(colors: soilColors,
                                            startPoint: CGPoint(x: 0.618, y: 0.9),
                                            endPoint: CGPoint(x: -0.2, y: 0),
                                            mask: layer)
        
                
        self.layer.addSublayer(soilLayer)
        
    }
    
    fileprivate func addLeavesLayer() {
        /// considering the rectangle as (0, 0, 100, 100)
        let leaves = [
            CGRect(x: 37, y: 25, width: 18, height: 24),
            CGRect(x: 48, y: 29, width: 14, height: 18),
            CGRect(x: 44, y: 20, width: 14, height: 20),
            CGRect(x: 34, y: 29, width: 14, height: 17),
            CGRect(x: 54, y: 24, width: 12, height: 24),
            CGRect(x: 57, y: 32, width: 12, height: 12),
            CGRect(x: 41, y: 18, width: 10, height: 24),
            CGRect(x: 30, y: 32, width: 12, height: 12),
            CGRect(x: 48, y: 29, width: 14, height: 18),
            CGRect(x: 48, y: 29, width: 14, height: 18),
            CGRect(x: 48, y: 29, width: 14, height: 18),
        ]
                
        let index = max(Int(Double(leaves.count) * branchesScore/10) - 1, 2)
        let earnedLeaves = leaves.prefix(index)
        for leaf in earnedLeaves {
            let transformX = leaf.minX * bounds.width / 100
            let transformY = leaf.minY * bounds.height / 100
            let transformWidth = leaf.width * bounds.width / 100
            let transformHeight = leaf.height * bounds.height / 100
            let leafRect = CGRect(x: transformX,
                                  y: transformY,
                                  width: transformWidth,
                                  height: transformHeight)
            let radius = leaf.width * bounds.width / 400
            let path = UIBezierPath(roundedRect: leafRect, cornerRadius: radius)
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = layer.bounds
            shapeLayer.path = path.cgPath
            
            let gradientLayer = createGradientLayer(colors: leafColors,
                                                    startPoint: CGPoint(x: 0.6, y: 1),
                                                    endPoint: CGPoint(x: 0.3, y: 0),
                                                    type: .axial,
                                            mask: shapeLayer)
            gradientLayer.opacity = 0.5
            layer.addSublayer(gradientLayer)
        }
    }
    
    fileprivate func createGradientLayer(colors: [UIColor],
                                         startPoint: CGPoint,
                                         endPoint: CGPoint,
                                         type: CAGradientLayerType = .radial,
                                         mask: CAShapeLayer) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        
        layer.mask = mask
        layer.frame = self.layer.bounds
        
        layer.type = type
        layer.frame = mask.frame
        
        return layer
    }
    
}
