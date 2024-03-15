//
//  Option.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation
import RealmSwift

class Option: Object {
    @Persisted var shortBreakTime: Int
    @Persisted var longBreakTime: Int
    @Persisted var focusTime: Int
    @Persisted var isVibrate: Bool

    convenience init(shortBreakTime: Int, longBreakTime: Int, focusTime: Int = 25, isVibrate: Bool = true) {
        self.init()
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
        self.focusTime = focusTime
        self.isVibrate = isVibrate
    }
}
