//
//  UIView+addSubviews.swift
//  MultiTimer
//
//  Created by Apex on 12.07.2021.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { (view) in
            addSubview(view)
        }
    }
}
