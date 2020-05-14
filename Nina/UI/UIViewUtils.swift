//
//  UIVIewUtils.swift
//  LanaUI
//
//  Created by Emannuel Carvalho on 09/04/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    
    func fill(view: UIView, flexibleBottom: Bool = false, margin: CGFloat = 0) {
        if superview == nil {
            view.addSubview(self)
        }
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
        ])
        if flexibleBottom {
            self.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
        }
    }
    
    func fill(with views: [UIView],
              margin: CGFloat = 0,
              axis: NSLayoutConstraint.Axis = .vertical,
              alignment: UIStackView.Alignment = .center,
              spacing: CGFloat = 0,
              distribution: UIStackView.Distribution = .fillProportionally) {
        
        let stackView = UIStackView(arrangedSubviews: views).notTranslating()
        stackView.axis = axis
        stackView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        stackView.fill(view: self, flexibleBottom: true)
    }
    
    func attachToTop(at view: UIView, margin: CGFloat = 0) {
        if self.superview == nil {
            view.addSubview(self)
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
        ])
    }
    
    func attachToBottom(at view: UIView, margin: CGFloat = 0) {
        if self.superview == nil {
            view.addSubview(self)
        }
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
        ])
    }
    
    func constraintRectangle(width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func constraintSquare(side: CGFloat) {
        constraintRectangle(width: side, height: side)
    }
    
    var deviceWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var context: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
}

///////////////////////////////////////////////////////////////////
protocol Translatable: class {
    func translate()
    func dontTranslate()
    func notTranslating() -> Self
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
}

extension Translatable {
    func translate() {
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    func dontTranslate() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func translating() -> Self {
        translate()
        return self
    }
    
    func notTranslating() -> Self {
        dontTranslate()
        return self
    }
}

protocol Fontable: class {
    var font: UIFont! { get set }
    
    func fonted(font: UIFont) -> Self
}

extension Fontable {
    func fonted(font: UIFont) -> Self {
        self.font = font
        return self
    }
}

protocol Backgroundable: class {
    var backgroundColor: UIColor? { get set }
    
    func backgrounded(color: UIColor) -> Self
}

extension Backgroundable {
    func backgrounded(color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
}

protocol TextColorable: class {
    var textColor: UIColor! { get set }
    
    func textColored(color: UIColor) -> Self
}

extension TextColorable {
    func textColored(color: UIColor) -> Self {
        textColor = color
        return self
    }
}

protocol TextCenterable: class {
    var textAlignment: NSTextAlignment { get set }
    
    func centered() -> Self
}

extension TextCenterable {
    
    func centered() -> Self {
        textAlignment = .center
        return self
    }
}

protocol RadiusConfigurable: class {
    var layer: CALayer { get }
    
    func radiusConfigured(radius: CGFloat) -> Self
}

extension RadiusConfigurable {
    
    func radiusConfigured(radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        return self
    }
}

///////////////////////////////////////////////////////////////////
extension UIView: Translatable {}
extension UIView: Backgroundable {}
extension UILabel: TextColorable {}
extension UILabel: TextCenterable {}
extension UILabel: Fontable {}
extension UIView: RadiusConfigurable {}
