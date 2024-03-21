//
//  PomodoroStepStateManager.swift
//  Pomodoro
//
//  Created by 진세진 on 3/11/24.
//

import UIKit

class PomodoroStepManger {
    var router = PomodoroRouter.shared
    var label = PomodoroStepLabel()
    var timeSetting = PomodoroStepTimeChage()

    func setRouterObservers() {
        router.addObservers(observer: label)
        router.addObservers(observer: timeSetting)
        router.notifyObservers()
    }
}
