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
    private var notificationId: String?

    private let userDefaults = UserDefaults.standard

    private(set) var currentTime = 0

    func setupCurrentTime(curr: Int) {
        currentTime = curr
    }

    func add1secToCurrentTime() {
        currentTime += 1
    }

    private(set) var maxTime = 0

    func setupMaxTime(time: Int) {
        maxTime = time
    }

    func startTimer(timerBlock: @escaping ((Timer, Int, Int) -> Void)) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerBlock(timer, self.currentTime, self.maxTime)
        }

        notificationId = UUID().uuidString

        let content = UNMutableNotificationContent()
        content.title = "시간 종료!"
        content.body = "시간이 종료되었습니다. 휴식을 취해주세요."

        let request = UNNotificationRequest(
            identifier: notificationId!,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(maxTime),
                repeats: false
            )
        )

        UNUserNotificationCenter.current()
            .add(request)
    }

    func stopTimer(completion: () -> Void) {
        pomodoroTimer?.invalidate()
        currentTime = 0
        maxTime = 0

        completion()
    }

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
