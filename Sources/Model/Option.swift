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
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var shortBreakTime: Int
    @Persisted var longBreakTime: Int
    @Persisted var isVibrate: Bool
    @Persisted var isTimerEffect: Bool

    convenience init(
        shortBreakTime: Int = 5,
        longBreakTime: Int = 20,
        isVibrate: Bool = false,
        isTimerEffect: Bool = true
    ) {
        self.init()
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
        self.isVibrate = isVibrate
        self.isTimerEffect = isTimerEffect
    }
}
