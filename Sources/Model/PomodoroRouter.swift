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
}

protocol PomodoroStepRememberable: AnyObject {
    func remembercurrentStep(currentStep: PomodoroTimerStep)
}

final class PomodoroRouter {
    let maxStep = 2
    static var pomodoroCount: Int = 0
    weak var delegate: PomodoroStepRememberable?

    var currentStep: PomodoroTimerStep = .start

    func moveToNextStep(navigationController: UINavigationController) {
        currentStep = checkCurrentStep()
        delegate?.remembercurrentStep(currentStep: currentStep)
        navigatorToCurrentStep(
            currentStep: currentStep,
            navigationController: navigationController
        )
    }

    func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
        let pomodoroTimerViewController = MainViewController()
        let breakTimerViewController = BreakTimerViewController()

        switch currentStep {
        case .start:
            pomodoroTimerViewController.router = self
            navigationController.pushViewController(pomodoroTimerViewController, animated: true)
        case .focus:
            pomodoroTimerViewController.router = self
            navigationController.pushViewController(pomodoroTimerViewController, animated: true)
        case .rest:
            if maxStep < PomodoroRouter.pomodoroCount {
                pomodoroTimerViewController.router = self
                navigationController.popToRootViewController(animated: true)
            } else {
                breakTimerViewController.router = self
                navigationController.pushViewController(breakTimerViewController, animated: true)
            }
        }
    }

    func checkCurrentStep() -> PomodoroTimerStep {
        switch currentStep {
        case .start:
            PomodoroRouter.pomodoroCount = 0
            currentStep = .rest(count: PomodoroRouter.pomodoroCount)
        case let .focus(count):
            currentStep = .rest(count: count)
        case var .rest(count):
            count = PomodoroRouter.pomodoroCount
            if count < maxStep {
                PomodoroRouter.pomodoroCount += 1
                currentStep = .focus(count: PomodoroRouter.pomodoroCount)
            } else {
                PomodoroRouter.pomodoroCount = 0
                currentStep = .start
            }
        }
        return currentStep
    }
}
