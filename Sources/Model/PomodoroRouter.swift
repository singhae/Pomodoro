//
//  PomodoroRouter.swift
//  Pomodoro
//
//  Created by 진세진 on 2/26/24.
//

import UIKit

class PomodoroRouter {
    enum PomodoroTimerStep {
        case focus(count: Int)
        case rest(count: Int)
        case end
    }

    private var currentStep: PomodoroTimerStep = .focus(count: 0)
    private var maxStep = 2
    private static var pomodoroCount: Int = 0

    func moveToNextStep(navigationController: UINavigationController) {
        switch currentStep {
        case var .focus(count):
            count = PomodoroRouter.pomodoroCount
            if count > maxStep {
                PomodoroRouter.pomodoroCount = 0
                count = 0
                currentStep = .focus(count: PomodoroRouter.pomodoroCount)
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
            currentStep = .focus(count: PomodoroRouter.pomodoroCount)
            return
        }

        navigatorToCurrentStep(currentStep: currentStep, navigationController: navigationController)
    }

    private func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
        let mainViewController = MainViewController()
        let breakTimerViewController = BreakTimerViewController()
        switch currentStep {
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
