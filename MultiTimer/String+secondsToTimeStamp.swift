//
//  String+SecondsToTimeStamp.swift
//  MultiTimer
//
//  Created by Apex on 13.07.2021.
//

import Foundation

extension String {
    func secondsToTimeStamp(_ seconds: Int) -> String {
        let (computedHours, computedMinutes, computedSeconds) =
            (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let stringHours = (computedHours > 0) ? "\(computedHours):" : ""
        let stringMinutes = (computedMinutes < 10) ? "0\(computedMinutes):" : "\(computedMinutes):"
        let stringSeconds = (computedSeconds < 10) ? "0\(computedSeconds)" : "\(computedSeconds)"
        return stringHours + stringMinutes + stringSeconds
    }
}
