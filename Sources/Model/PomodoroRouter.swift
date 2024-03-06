//
//  PomodoroRouter.swift
//  Pomodoro
//
//  Created by 진세진 on 2/26/24.
//

import UIKit

enum PomodoroTimerStep {
    case start
    case focus(count: Int)
    case rest(count: Int)
    case end
}

// - MARK: PomodoroRouter 의 역할은 현재 단계 기억하고 다음 단계로 넘기기(페이지)
final class PomodoroStepTimerManager {
    private var router: PomodoroRouter?
    private let pomodoroTimeManager = PomodoroTimeManager.shared

    init(router: PomodoroRouter) {
        self.router = router
    }

    private func setUpcurrentPomodoroTime() {
        switch router?.currentStep {
        case .start:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case let .focus(count):
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case let .rest(count):
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case .end:
            fristPomodoroCount()
        case .none:
            return
        }
    }

    func setUpCurrentStepLabel() -> String {
        switch router?.currentStep {
        case .start:
            return ""
        case let .focus(count), let .rest(count):
            return String(count) + "회차"
        case .end:
            return ""
        case .none:
            return ""
        }
    }

    func fristPomodoroCount() {
        router?.initPomodoroCount()
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }
}

class PomodoroRouter {
    private var maxStep = 2
    private static var pomodoroCount: Int = 0
    var currentStep: PomodoroTimerStep = .start

    func moveToNextStep(navigationController: UINavigationController) {
        switch currentStep {
        case .start:
            currentStep = .rest(count: 0)
        case let .focus(count):
            currentStep = .rest(count: count)
        case var .rest(count):
            count = PomodoroRouter.pomodoroCount
            if count < maxStep {
                PomodoroRouter.pomodoroCount += 1
                currentStep = .focus(count: count + 1)
            } else {
                currentStep = .end
            }
        case .end:
            initPomodoroCount()
        }

        navigatorToCurrentStep(
            currentStep: currentStep,
            navigationController: navigationController
        )
    }

    func initPomodoroCount() {
        PomodoroRouter.pomodoroCount = 0
        currentStep = .start
    }

    private func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
        // mainViewController 이름을 바꿔봅시다!
        let mainViewController = MainViewController()
        let breakTimerViewController = BreakTimerViewController()

        switch currentStep {
        case .start:
            mainViewController.router = self
            navigationController.setViewControllers([mainViewController], animated: true)
        case .focus:
            mainViewController.router = self
            navigationController.setViewControllers([mainViewController], animated: true)
        case .rest:
            breakTimerViewController.router = self
            navigationController.pushViewController(breakTimerViewController, animated: true)
        case .end:
            mainViewController.router = self
            navigationController.popToRootViewController(animated: true)
        }
    }
}
