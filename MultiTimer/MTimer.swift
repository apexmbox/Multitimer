//
//  Timer.swift
//  MultiTimer
//
//  Created by Apex on 12.07.2021.
//

import Foundation

struct MTimer: Identifiable {
    
    let id: Int
    let name: String
    var startTime: Date
    var estimatedTime: Double
    var timer: Timer
    
    private static var idFactory = 0
    
    private static func getUniqueId() -> Int
    {
        idFactory += 1
        return idFactory
    }
    
    init(name timerName: String, estimatedTime time: Double) {
        self.id = MTimer.getUniqueId()
        self.name = timerName
        self.startTime = Date()
        self.estimatedTime = time
        self.timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false) { _ in }
    }
    
    mutating func start() {
        self.startTime = Date()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.estimatedTime, repeats: false) { _ in }
    }
    
    mutating func pause() {
        self.estimatedTime -= Date().timeIntervalSince(self.startTime)
        self.timer.invalidate()
    }
}
