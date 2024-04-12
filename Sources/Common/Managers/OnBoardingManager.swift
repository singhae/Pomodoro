//
//  OnBoardingManager.swift
//  Pomodoro
//
//  Created by 김현기 on 4/2/24.
//

import Foundation

class OnboardingManager {
    static let shared = OnboardingManager()
    private let pomodoroTimeManager = PomodoroTimeManager.shared

    func checkOnboarding() -> Bool {
        let userDefaults = UserDefaults.standard

        if userDefaults.object(forKey: "isFirstTime") == nil {
            userDefaults.set("No", forKey: "isFirstTime")
            Log.info("ONBOARDING 맞음")
            return true
        } else {
            Log.info("ONBOARDING 아님")
            return false
        }
    }
}
