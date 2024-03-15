//
//  DashBoard.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation
import RealmSwift

class DashBoard: Object {
    @Persisted var participateDateCount: Int
    @Persisted var totalCount: Int
    @Persisted var success: Int
    @Persisted var failure: Int

    convenience init(
        participateDateCount: Int = 0,
        totalCount: Int = 0,
        success: Int = 0,
        failure: Int = 0
    ) {
        self.init()
        self.participateDateCount = participateDateCount
        self.totalCount = totalCount
        self.success = success
        self.failure = failure
    }
}
