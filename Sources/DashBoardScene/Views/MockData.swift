//
//  MockData.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/27.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit

// MARK: - 임시 PomodoroData
struct PomodoroData {
    var breakTime: Int
    var focusTime: Int
    var tagId: String
    var participateDate: Int
    var success: Bool
}

let pomodoroSessions = [
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: 2, success: true),
    PomodoroData(breakTime: 5, focusTime: 30, tagId: "운동", participateDate: 2, success: false),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: 2, success: false),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: 2, success: false),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: 2, success: false),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: 2, success: true),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: 2, success: true),
    PomodoroData(breakTime: 5, focusTime: 25, tagId: "스터디", participateDate: 2, success: true),
    PomodoroData(breakTime: 5, focusTime: 20, tagId: "스터디", participateDate: 2, success: true),
]

struct TotalPomodoro {
    var totalSessions: Int
    var totalSuccesses: Int
    var totalFailures: Int
    var totalDate: Int

    init(sessions: [PomodoroData]) {
        self.totalSessions = sessions.count
        self.totalSuccesses = sessions.filter { $0.success }.count
        self.totalFailures = sessions.filter { !$0.success }.count
        self.totalDate = 0
    }
}

let statistics = TotalPomodoro(sessions: pomodoroSessions)

// MARK: - 임시 tag Data
struct Tag {
    var uid: String
    var tagName: String
    var tagDescription: String
}

let tags = [
    Tag(uid: "1", tagName: "공부", tagDescription: "이산수학 공부"),
    Tag(uid: "2", tagName: "운동", tagDescription: "필라테스"),
    Tag(uid: "3", tagName: "스터디", tagDescription: "iOS 스터디"),
]
