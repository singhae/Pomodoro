//
//  Pomodoro.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation
//import RealmSwift
import UIKit

class Pomodoro {
    var phase: Int
    var currentTag: String
    var participateDate: Date
    var success: Bool

    init(phase: Int, currentTag: String = "집중", participateDate: Date = Date(), success: Bool = false) {
        self.phase = phase
        self.currentTag = currentTag
        self.participateDate = participateDate
        self.success = success
    }
}
