//
//  TimerModel.swift
//  MultiTimer
//
//  Created by Apex on 13.07.2021.
//

import UIKit

class TimerModel {

    var timers: [MTimer] = []
    
    func getAllTimers() -> [MTimer] {
        return timers
    }

    func addTimer(name timerName: String, duration timerDuration: Double) {
        let newTimer = MTimer(name: timerName, estimatedTime: timerDuration)
        timers.append(newTimer)
    }
    
    func removeInactiveTimers(){
        var new_timers: [MTimer] = []
        for index in 0..<timers.count {
            if timers[index].timer.isValid || Int(timers[index].estimatedTime) > 0 {
                new_timers.append(timers[index])
            }
        }
        new_timers.sort() { $0.estimatedTime > $1.estimatedTime }
        timers = new_timers
    }
}
