//
//  String+isInt.swift
//  MultiTimer
//
//  Created by Apex on 14.07.2021.
//

import Foundation

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
