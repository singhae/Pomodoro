//
//  MockData.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/27.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit

// FIXME: - 임시로 사용하는 PomodoroData입니다.
struct PomodoroData {
    var breakTime: Int
    var focusTime: Int
    var tagId: String
    var participateDate: Int
    var success: Bool
    
    static var dummyData: [PomodoroData] {
        return [
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
    }
}

struct TotalPomodoro {
    var totalSessions: Int
    var totalSuccesses: Int
    var totalFailures: Int
    var totalDate: Int

    init(sessions: [PomodoroData]) {
        self.totalSessions = sessions.count
        self.totalSuccesses = sessions.filter { $0.success }.count
        self.totalFailures = sessions.filter { !$0.success }.count
        self.totalDate = 1
    }
}

// FIXME: - 임시로 사용하는 MockData입니다.
struct Tag {
    var uid: String
    var tagName: String
    var tagDescription: String
    
    static var dummyData: [Tag] {
        return [
            Tag(uid: "1", tagName: "공부", tagDescription: "이산수학 공부"),
            Tag(uid: "2", tagName: "운동", tagDescription: "필라테스"),
            Tag(uid: "3", tagName: "스터디", tagDescription: "iOS 스터디"),
        ]
    }
}
