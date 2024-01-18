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
    var participateDate: Date
    var success: Bool

    static var dummyData: [PomodoroData] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let defaultDate = Date()
        
        return [
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: dateFormatter.date(from: "2024-01-01") ?? defaultDate, success: true),
            PomodoroData(breakTime: 5, focusTime: 30, tagId: "운동", participateDate: dateFormatter.date(from: "2024-01-04") ?? defaultDate, success: false),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: dateFormatter.date(from: "2024-01-04") ?? defaultDate, success: true),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: dateFormatter.date(from: "2024-01-08") ?? defaultDate, success: false),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "운동", participateDate: dateFormatter.date(from: "2024-01-12") ?? defaultDate, success: false),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: dateFormatter.date(from: "2024-01-09") ?? defaultDate, success: true),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "공부", participateDate: dateFormatter.date(from: "2024-01-02") ?? defaultDate, success: true),
            PomodoroData(breakTime: 5, focusTime: 25, tagId: "스터디", participateDate: dateFormatter.date(from: "2024-01-02") ?? defaultDate, success: true),
            PomodoroData(breakTime: 5, focusTime: 20, tagId: "스터디", participateDate: dateFormatter.date(from: "2024-01-17") ?? defaultDate, success: true),
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
struct TempTag {
    var uid: String
    var tagName: String
    var tagDescription: String

    static var dummyData: [TempTag] {
        return [
            TempTag(uid: "1", tagName: "공부", tagDescription: "이산수학 공부"),
            TempTag(uid: "2", tagName: "운동", tagDescription: "필라테스"),
            TempTag(uid: "3", tagName: "스터디", tagDescription: "iOS 스터디"),
        ]
    }
}
