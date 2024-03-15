//
//  PomodoroStepStateManager.swift
//  Pomodoro
//
//  Created by 진세진 on 3/11/24.
//

import UIKit

final class PomodoroStepStateManager {
    var router: PomodoroRouter?
    private let pomodoroTimeManager = PomodoroTimeManager.shared
    private var pomodoroCurrentCount = PomodoroRouter.pomodoroCount

    init(router: PomodoroRouter) {
        self.router = router
    }

    func applyStepChanges(navigationController: UINavigationController) {
        router?.moveToNextStep(navigationController: navigationController)
        setUptimeInCurrentStep()
        setUpLabelInCurrentStep()
    }

    func setUptimeInCurrentStep() {
        switch router?.currentStep {
        case .start:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        case .focus, .rest:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case .none:
            return
        }
    }

    func setUpLabelInCurrentStep() -> String {
        switch router?.currentStep {
        case .start:
            return ""
        case var .rest(count), var .focus(count):
            count = pomodoroCurrentCount
            if count == .zero {
                return ""
            }
            return "\(count) 회차"
        case .none:
            return ""
        }
    }

    func initPomodoroStep() {
        router?.currentStep = .start
        PomodoroRouter.pomodoroCount = 0
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }
}
