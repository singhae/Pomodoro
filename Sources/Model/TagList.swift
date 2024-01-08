//
//  TagList.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Foundation
//import RealmSwift
import UIKit

class TagList {
    var tagList: [Tag] = [
        Tag(tagName: "집중", tagColor: .red),
        Tag(tagName: "업무", tagColor: .blue)
    ]

    func addTag(tagName: String, tagColor: UIColor) {}

    func removeTag(tagName: String) {}
}

class Tag {
    var tagName: String
    var tagColor: UIColor

    init(tagName: String, tagColor: UIColor) {
        self.tagName = tagName
        self.tagColor = tagColor
    }
}
