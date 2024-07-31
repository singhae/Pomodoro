//
//  PomodoroTimeManager.swift
//  Pomodoro
//
//  Created by 김현기 on 2/13/24.
//

import Foundation
import UserNotifications

final class PomodoroTimeManager {
    static let shared = PomodoroTimeManager()
    private init() {}

    private var pomodoroTimer: Timer?
    private let userDefaults = UserDefaults.standard
    private let notificationId = UUID().uuidString

    private(set) var currentTime = 0

    func setupCurrentTime(curr: Int) {
        currentTime = curr
    }

    private(set) var maxTime = 0

    func setupMaxTime(time: Int) {
        maxTime = time
    }

    private(set) var isRestored: Bool = false

    func setupIsRestored(bool: Bool) {
        isRestored = bool
    }

    private(set) var isStarted: Bool = false

    func setupIsStarted(bool: Bool) {
        isStarted = bool
    }

    func startTimer(timerBlock: @escaping ((Timer, Int, Int) -> Void)) {
        guard maxTime > 0 else {
            print("Error: maxTime must be greater than 0. Current maxTime: \(maxTime)")
            return
        }

        pomodoroTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerBlock(timer, self.currentTime + 1, self.maxTime)
            self.currentTime += 1
        }
        pomodoroTimer?.fire()
    }

    func stopTimer(completion: () -> Void) {
        pomodoroTimer?.invalidate()
        pomodoroTimer = nil
        currentTime = 0

        let recent = try? RealmService.read(Pomodoro.self).last
        maxTime = (recent?.phaseTime ?? 25) * 60

        completion()
    }

    func saveTimerInfo() {
        if UserDefaults.standard.bool(forKey: "isFirstVisit") {
            UserDefaults.standard.set(false, forKey: "isFirstVisit")
        } else {
            let lastSavedDate = Date.now
            isRestored = false

            userDefaults.set(lastSavedDate, forKey: "realTime")
            userDefaults.set(currentTime, forKey: "currentTime")
            userDefaults.set(maxTime, forKey: "maxTime")
        }
    }

    func restoreTimerInfo() {
        guard let previousTime = userDefaults.object(forKey: "realTime") as? Date,
              let existCurrentTime = userDefaults.object(forKey: "currentTime") as? Int,
              let existMaxTime = userDefaults.object(forKey: "maxTime") as? Int
        else {
            // 사용자 기본값이 없는 경우, 초기 설정을 합니다.
            maxTime = 25 * 60 // 기본 최대 시간을 25분으로 설정
            currentTime = 0
            isRestored = false
            return
        }

        let realTime = Date.now

        // 이전 시간과 현재 시간 간의 차이 계산
        let elapsedTime = Int(realTime.timeIntervalSince(previousTime))
        let updatedCurrTime = existCurrentTime + elapsedTime

        // 최대 시간과 현재 시간 업데이트
        maxTime = existMaxTime

        // 최대 시간이 현재 시간보다 크면 복원
        if maxTime > updatedCurrTime {
            isRestored = true
            currentTime = updatedCurrTime
        } else {
            // 최대 시간이 현재 시간보다 작으면 타이머를 초기화
            let recent = try? RealmService.read(Pomodoro.self).last
            maxTime = (recent?.phaseTime ?? 25) * 60
            currentTime = 0
            isRestored = false // 복원이 실패했으므로 false로 설정
        }
    }
}
