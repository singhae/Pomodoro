//
//  Pomodoro.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import RealmSwift
import UIKit

// class PomodoroList: Object {
//    @Persisted var pomodoroList: List<Pomodoro>
//
//    let defaultPomodoro: [Pomodoro] = [
//        Pomodoro(phase: 4, currentTag: "공부", participateDate: Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 28)) ?? Date.now, isSuccess: true),
//        Pomodoro(phase: 4, currentTag: "운동", participateDate: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 8)) ?? Date.now, isSuccess: false),
//        Pomodoro(phase: 4, currentTag: "스터디", participateDate: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 12)) ?? Date.now, isSuccess: true)
//    ]
//
//    convenience init(pomodoroList: List<Pomodoro>) {
//        self.init()
//        self.pomodoroList = pomodoroList
//        self.pomodoroList.append(objectsIn: defaultPomodoro)
//    }
//
//    func addPomodoro(phase: Int, tagName: String, date: Date, isSuccess: Bool) {
//        pomodoroList.append(
//            Pomodoro(
//                phase: phase,
//                currentTag: tagName,
//                participateDate: date,
//                isSuccess: isSuccess
//            )
//        )
//    }
// }

class Pomodoro: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var phase: Int // 1 -> 2 -> 3 -> 4 순으로 가되, 뽀모도로가 모두 완료되면 (성공이든, 실패이든 0으로 변경)
    @Persisted var currentTag: String
    @Persisted var participateDate: Date
    @Persisted var isSuccess: Bool

    convenience init(
        id: Int,
        phase: Int = 1,
        currentTag: String = "DEFAULT",
        participateDate: Date = Date.now,
        isSuccess: Bool = false
    ) {
        self.init()
        self.id = id
        self.phase = phase
        self.currentTag = currentTag
        self.participateDate = participateDate
        self.isSuccess = isSuccess
    }
}
