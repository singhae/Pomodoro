//
//  TagList.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation

// import RealmSwift
import UIKit

class TagList {
    var tagList: [Tag] = [
        Tag(tagName: "집중", tagColor: .blue),
        Tag(tagName: "업무", tagColor: .red),
        Tag(tagName: "공부", tagColor: .green),
        Tag(tagName: "운동", tagColor: .purple),
        Tag(tagName: "스터디", tagColor: .yellow)
    ]

    func addTag(tagName _: String, tagColor _: UIColor) {}

    func removeTag(tagName _: String) {}
}

class Tag {
    var tagName: String
    var tagColor: UIColor

    init(tagName: String, tagColor: UIColor) {
        self.tagName = tagName
        self.tagColor = tagColor
    }
}
