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
            print("ONBOARDING 맞음")
            return true
        } else {
            print("ONBOARDING 아님")
            return false
        }
    }
}
