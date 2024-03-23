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

protocol PomodoroStepObserver: AnyObject {
    func didPomodoroStepChange(to step: PomodoroTimerStep)
}

final class PomodoroRouter {
    static let shared = PomodoroRouter()
    let maxStep = 2
    static var pomodoroCount: Int = 0

    var observers: [PomodoroStepObserver] = []
    var currentStep: PomodoroTimerStep = .start {
        didSet {
            notifyObservers()
        }
    }

    func addObservers(observer: PomodoroStepObserver) {
        observers.append(observer)
    }

    func notifyObservers() {
        for observer in observers {
            observer.didPomodoroStepChange(to: currentStep)
        }
    }

    func moveToNextStep(navigationController: UINavigationController) {
        currentStep = checkCurrentStep()
        print(currentStep)
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
            pomodoroTimerViewController.stepManager.router = self
            navigationController.pushViewController(pomodoroTimerViewController, animated: true)
        case .focus:
            pomodoroTimerViewController.stepManager.router = self
            navigationController.pushViewController(pomodoroTimerViewController, animated: true)
        case .rest:
            if maxStep < PomodoroRouter.pomodoroCount {
                pomodoroTimerViewController.stepManager.router = self
                navigationController.popToRootViewController(animated: true)
            } else {
                breakTimerViewController.stepManager.router = self
                navigationController.pushViewController(breakTimerViewController, animated: true)
            }
        case .end:
            breakTimerViewController.stepManager.router = self
            navigationController.popToRootViewController(animated: true)
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
            } else if count == maxStep {
                currentStep = .end
            } else {
                PomodoroRouter.pomodoroCount = 0
                currentStep = .end
            }
        case .end:
            PomodoroRouter.pomodoroCount = 0
        }
        return currentStep
    }
}

final class PomodoroStepTimeChage {
    private let pomodoroTimeManager = PomodoroTimeManager.shared
    private var pomodoroCurrentCount = PomodoroRouter.pomodoroCount

    func setUptimeInCurrentStep(currentStep: PomodoroTimerStep) {
        switch currentStep {
        case .start:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        case .focus, .rest:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case .end:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        }
    }

    func initPomodoroStep() {
        PomodoroRouter.pomodoroCount = 0
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }
}

extension PomodoroStepTimeChage: PomodoroStepObserver {
    func didPomodoroStepChange(to step: PomodoroTimerStep) {
        setUptimeInCurrentStep(currentStep: step)
    }
}

final class PomodoroStepLabel {
    private var pomodoroCurrentCount = PomodoroRouter.pomodoroCount
    private var currentStep: PomodoroTimerStep = .start

    func setUpLabelInCurrentStep(currentStep: PomodoroTimerStep) -> String {
        switch currentStep {
        case .start:
            return ""
        case var .rest(count), var .focus(count):
            count = pomodoroCurrentCount
            if count == .zero {
                return ""
            }
            return "\(count) 회차"
        case .end:
            return ""
        }
    }
}

extension PomodoroStepLabel: PomodoroStepObserver {
    func didPomodoroStepChange(to step: PomodoroTimerStep) {
        setUpLabelInCurrentStep(currentStep: step)
    }
}
