//
//  PomodoroTimeManager.swift
//  Pomodoro
//
//  Created by 김현기 on 2/13/24.
//

import Foundation

final class PomodoroTimeManager {
    static let shared = PomodoroTimeManager()

    private init() {}

    private let userDefaults = UserDefaults.standard

    private(set) var currentTime = 0

    func setupCurrentTime(curr: Int) {
        currentTime = curr
    }

    var maxTime = 0

    func saveTimerInfo() {
        let lastSavedDate = Date.now

        userDefaults.set(lastSavedDate, forKey: "realTime")
        userDefaults.set(currentTime, forKey: "currentTime")
        userDefaults.set(maxTime, forKey: "maxTime")
    }

    func restoreTimerInfo() {
        guard let previousTime = userDefaults.object(forKey: "realTime") as? Date,
              let existCurrentTime = userDefaults.object(forKey: "currentTime") as? Int,
              let existMaxTime = userDefaults.object(forKey: "maxTime") as? Int
        else {
            return
        }

        let realTime = Date.now

        let updatedCurrTime = existCurrentTime + Int(realTime.timeIntervalSince(previousTime))
        maxTime = existMaxTime

        if maxTime > updatedCurrTime {
            currentTime = updatedCurrTime
        } else {
            maxTime = 0
            currentTime = 0
        }
    }
}
