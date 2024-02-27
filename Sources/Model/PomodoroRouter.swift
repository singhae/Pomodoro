//
//  PomodoroRouter.swift
//  Pomodoro
//
//  Created by 진세진 on 2/26/24.
//

import UIKit

class PomodoroRouter {
    enum PomodoroTimerStep {
        case start
        case focus(count: Int)
        case rest(count: Int)
        case end
    }

    private var currentStep: PomodoroTimerStep = .focus(count: 0)
    private var maxStep = 3
    private static var pomodoroCount: Int = 0

    func nextToSetp(navigationController: UINavigationController) {
        switch currentStep {
        case .start:
            currentStep = .focus(count: 0)
        case var .focus(count):
            count = PomodoroRouter.pomodoroCount

            if count > maxStep {
                PomodoroRouter.pomodoroCount = 0
                count = 0
                currentStep = .start
            }
            currentStep = .rest(count: count)
        case var .rest(count):
            PomodoroRouter.pomodoroCount += 1
            count = PomodoroRouter.pomodoroCount

            if count < maxStep {
                currentStep = .focus(count: count)
            } else {
                PomodoroRouter.pomodoroCount = 0
                currentStep = .end
            }
        case .end:
            currentStep = .start
            return
        }

        navigatorToCurrentStep(currentStep: currentStep, navigationController: navigationController)
    }

    func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
        let mainViewController = MainViewController()
        let breakTimerViewController = BreakTimerViewController()
        if case .end = currentStep {
            navigationController.popToRootViewController(animated: true)
        } else {
            if case .focus = currentStep {
                mainViewController.router = self
                navigationController.setViewControllers([mainViewController], animated: true)
            } else if case .rest = currentStep {
                breakTimerViewController.router = self
                navigationController.pushViewController(breakTimerViewController, animated: true)
            }
        }
    }
}
