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

    private static var currentStep: PomodoroTimerStep = .start
    private var maxStep = 2
    private static var pomodoroCount: Int = 0
    private let pomodoroTimeManager = PomodoroTimeManager.shared

    func moveToNextStep(navigationController: UINavigationController) {
        switch PomodoroRouter.currentStep {
        case .start:
            PomodoroRouter.currentStep = .rest(count: 0)
        case let .focus(count):
            PomodoroRouter.currentStep = .rest(count: count)
        case var .rest(count):
            count = PomodoroRouter.pomodoroCount
            if count < maxStep {
                PomodoroRouter.pomodoroCount += 1
                PomodoroRouter.currentStep = .focus(count: count + 1)
            } else {
                PomodoroRouter.currentStep = .end
            }
        case .end:
            initPomodoroCount()
        }

        setUpcurrentPomodoroTime()
        navigatorToCurrentStep(
            currentStep: PomodoroRouter.currentStep,
            navigationController: navigationController
        )
    }

    func setUpCurrentStepLabel() -> String {
        switch PomodoroRouter.currentStep {
        case .start:
            return " "
        case let .focus(count), let .rest(count):
            return String(count) + "회차"
        case .end:
            return ""
        }
    }

    func initPomodoroCount() {
        PomodoroRouter.pomodoroCount = 0
        PomodoroRouter.currentStep = .start
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }

    private func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
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

    private func setUpcurrentPomodoroTime() {
        switch PomodoroRouter.currentStep {
        case .start:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case let .focus(count):
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case let .rest(count):
            pomodoroTimeManager.setupCurrentTime(curr: -0)
        case .end:
            initPomodoroCount()
        }
    }
}
