//
//  PomodoroRouter.swift
//  Pomodoro
//
//  Created by 진세진 on 2/26/24.
//

import UIKit

enum PomodoroTimerStep: Equatable {
    case start
    case focus(count: Int)
    case rest(count: Int)
    case end
}

protocol PomodoroStepObserver: AnyObject {
    func didPomodoroStepChange(to step: PomodoroTimerStep)
    func didPomodoroStepCounterChange(stepCounter counter: Int)
}

// - MARK: PomodoroStepTimeChage - pomodoroStep의 변화에 따른 스텝단계의 변화와 navigator 관리
final class PomodoroRouter {
    static let shared = PomodoroRouter()
    let maxStep = 2
    var pomodoroCount: Int = 0 {
        didSet {
            savePomodoroStepCounter()
        }
    }

    private let pomodoroData = DatabaseManager.shared
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
            observer.didPomodoroStepCounterChange(stepCounter: pomodoroCount)
        }
    }

    func moveToNextStep(navigationController: UINavigationController) {
        currentStep = checkCurrentStep()
        Log.info(currentStep)
        navigatorToCurrentStep(
            currentStep: currentStep,
            navigationController: navigationController
        )
    }

    func savePomodoroStepCounter() {
        let data = pomodoroData.read(Pomodoro.self)
        guard let currentData = data.last else {
            return
        }
        pomodoroData.update(currentData) { data in
            data.phase = self.pomodoroCount
        }
    }

    func navigatorToCurrentStep(
        currentStep: PomodoroTimerStep,
        navigationController: UINavigationController
    ) {
        let pomodoroMainViewController = MainViewController()
        let pomodoroMainPageViewController = MainPageViewController()
        let breakTimerViewController = BreakTimerViewController()

        switch currentStep {
        case .start:
            pomodoroMainViewController.stepManager.router = self
            navigationController.pushViewController(pomodoroMainPageViewController, animated: true)
        case .focus:
            pomodoroMainViewController.stepManager.router = self
            navigationController.pushViewController(pomodoroMainPageViewController, animated: true)
        case .rest:
            if maxStep < pomodoroCount {
                pomodoroMainViewController.stepManager.router = self
                navigationController.popToRootViewController(animated: true)
            } else {
                breakTimerViewController.stepManager.router = self
                navigationController.pushViewController(breakTimerViewController, animated: true)
            }
        case .end:
            navigationController.popToRootViewController(animated: true)
        }
    }

    func checkCurrentStep() -> PomodoroTimerStep {
        switch currentStep {
        case .start:
            pomodoroCount = 0
            currentStep = .rest(count: pomodoroCount)
        case let .focus(count):
            currentStep = .rest(count: count)
        case var .rest(count):
            count = pomodoroCount
            if count < maxStep {
                pomodoroCount += 1
                currentStep = .focus(count: pomodoroCount)
            } else if count == maxStep {
                currentStep = .end
            } else {
                pomodoroCount = 0
                currentStep = .end
                currentStep = .start
            }
        case .end:
            pomodoroCount = 0
        }
        return currentStep
    }
}

// - MARK: PomodoroStepTimeChage - pomodoroStep 변화에 따른 시간의 변화를 관리하는 클래스

final class PomodoroStepTimeChange {
    private let pomodoroTimeManager = PomodoroTimeManager.shared
    private var pomodoroCurrentCount = PomodoroRouter.shared.pomodoroCount
    private var currentStep: PomodoroTimerStep?
    private var shortBreakTime: Int?
    private var longBreakTime: Int?

    func setUptimeInCurrentStep() {
        switch currentStep {
        case .start:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        case .focus, .rest:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
        case .end:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        case .none:
            pomodoroTimeManager.setupCurrentTime(curr: 0)
            pomodoroTimeManager.setupMaxTime(time: 0)
        }
    }

    func setUpBreakTime() -> Int {
        let options = (try? RealmService.read(Option.self).first) ?? Option()
        if pomodoroCurrentCount < 2 {
            return options.shortBreakTime
        } else {
            return options.longBreakTime
        }
    }

    func initPomodoroStepInRestTime() {
        pomodoroCurrentCount = 0
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }

    func stopPomodoroStep(currentTime time: Int) {
        pomodoroCurrentCount = 0
        stopPomodoroStep(time: time)
        pomodoroTimeManager.setupMaxTime(time: 0)
        pomodoroTimeManager.setupCurrentTime(curr: 0)
    }

    private func stopPomodoroStep(time: Int) {
        let data = pomodoroData.read(Pomodoro.self)
        guard let currentData = data.last else {
            return
        }
        if currentData.phase == 1 && time <= 60 {
            // 실패에 대한 카운팅 없애기
            pomodoroData.delete(currentData)
        } else {
            pomodoroData.update(currentData) { data in
                data.phase = 0
                data.isSuccess = false
            }
        }
    }
}

extension PomodoroStepTimeChage: PomodoroStepObserver {
    func didPomodoroStepCounterChange(stepCounter counter: Int) {
        pomodoroCurrentCount = counter
    }
extension PomodoroStepTimeChange: PomodoroStepObserver {
    func didPomodoroStepCounterChange(stepCounter counter: Int) {
        pomodoroCurrentCount = counter
    }
    func didPomodoroStepChange(to step: PomodoroTimerStep) {
        currentStep = step
    }
}

// - MARK: PomodoroStepLabel : 현재 스텝을 label로 보여주기
final class PomodoroStepLabel {
    private var pomodoroCurrentCount: Int?
    private var currentStep: PomodoroTimerStep = .start

    func setUpLabelInCurrentStep(currentStep: PomodoroTimerStep) -> String {
        switch currentStep {
        case .start:
            return ""
        case var .rest(count), var .focus(count):
            count = pomodoroCurrentCount ?? 0
            if count == .zero {
                return ""
            }
            return "\(count + 1) 회차"
        case .end:
            return ""
        }
    }
}

extension PomodoroStepLabel: PomodoroStepObserver {
    func didPomodoroStepCounterChange(stepCounter counter: Int) {
        pomodoroCurrentCount = counter
    }

    func didPomodoroStepChange(to step: PomodoroTimerStep) {
        _ = setUpLabelInCurrentStep(currentStep: step)
    }
}
