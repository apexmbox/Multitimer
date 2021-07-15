//
//  UIView+Layout.swift
//  MultiTimer
//
//  Created by Apex on 12.07.2021.
//

import UIKit

extension UIView {
    
    func edgesToSuperView(insets: UIEdgeInsets = .zero, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        var tempConstraints = [NSLayoutConstraint]()
        
        if edges.contains(.top) {
            let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
            tempConstraints.append(top)
        }
        
        if edges.contains(.bottom) {
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom)
            tempConstraints.append(bottom)
        }
        
        if edges.contains(.left) {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left)
            tempConstraints.append(left)
        }
        
        if edges.contains(.right) {
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor, constant: insets.right)
            tempConstraints.append(right)
        }
        
        NSLayoutConstraint.activate(tempConstraints)
    }
}
