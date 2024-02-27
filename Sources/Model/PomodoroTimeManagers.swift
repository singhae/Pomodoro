//
//  PomodoroTimeManagers.swift
//  Pomodoro
//
//  Created by 김현기 on 2/13/24.
//

import Foundation
import UIKit

class PomodoroTimeManager {
    static let shared = PomodoroTimeManager()

    private init() {}

    private let userDefaults = UserDefaults.standard

    var currentTime = 0
    var maxTime = 0
    private var elapsedTime = 0

    func saveTimerInfo() {
        // 현재 실제 시각 및 남은 타이머 시간 정보 저장
        print("SAVE INFOS..")
        let realTime = Date()
        elapsedTime = 0

        userDefaults.set(realTime, forKey: "realTime")
        userDefaults.set(currentTime, forKey: "currentTime")
        userDefaults.set(maxTime, forKey: "maxTime")
    }

    func restoreTimerInfo() {
        // 앱 재시작 시에 타이머 정보 불러오기
        guard let previousTime = userDefaults.object(forKey: "realTime") as? Date,
              let reCurrentTime = userDefaults.object(forKey: "currentTime") as? Int,
              let reMaxTime = userDefaults.object(forKey: "maxTime") as? Int
        else {
            return
        }

        // 재시작 시 현재 시간
        let realTime = Date()
        // 남은 시간
        elapsedTime = Int(realTime.timeIntervalSince(previousTime))
        let updatedCurrTime = reCurrentTime + elapsedTime
        maxTime = reMaxTime

        print("TIMER INVALIDATE")

        // 타이머 업데이트
        print("elapsedTime: \(elapsedTime), updatedTime: \(updatedCurrTime)")
        print("maxTime: \(maxTime), currentTime: \(currentTime)")
        if maxTime > updatedCurrTime {
            currentTime = updatedCurrTime
        } else {
            maxTime = 0
            currentTime = 0
        }
    }

    var isTimerExpired: Bool {
        // 남은 타이머 시간 초과 여부 확인
//        return (maxTime < currentTime)
        false
    }
}
