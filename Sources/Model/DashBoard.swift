//
//  DashBoard.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation

// import RealmSwift
import UIKit

class DashBoard {
    var pomodoroList: [Pomodoro]
    var participateDateCount: Int
    var totalCount: Int
    var success: Int
    var failure: Int

    init(
        pomodoroList: [Pomodoro],
        participateDateCount: Int = 0,
        totalCount: Int = 0,
        success: Int = 0,
        failure: Int = 0
    ) {
        self.pomodoroList = pomodoroList
        self.participateDateCount = participateDateCount
        self.totalCount = totalCount
        self.success = success
        self.failure = failure
    }
}
