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
}
