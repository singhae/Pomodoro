//
//  Option.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation
// import RealmSwift
import UIKit

class Option {
    var shortBreakTime: Int
    var longBreakTime: Int
    var focusTime: Int
    var isVibrate: Bool

    init(shortBreakTime: Int, longBreakTime: Int, focusTime: Int = 20, isVibrate: Bool = true) {
        self.shortBreakTime = shortBreakTime
        self.longBreakTime = longBreakTime
        self.focusTime = focusTime
        self.isVibrate = isVibrate
    }
}
