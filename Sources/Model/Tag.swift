//
//  Tag.swift
//  Pomodoro
//
//  Created by 김현기 on 12/27/23.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import Realm
import RealmSwift
import UIKit

enum TagCase: CaseIterable {
    case one, two, three, four, five, six, seven, eight

    var backgroundColor: UIColor {
        switch self {
        case .one:
            return UIColor.red
        case .two:
            return UIColor.green
        case .three:
            return UIColor.purple
        case .four:
            return UIColor.blue
        case .five:
            return UIColor.yellow
        case .six:
            return UIColor.cyan
        case .seven:
            return UIColor.orange
        case .eight:
            return UIColor.lightGray
        }
    }

    var tagColor: UIColor {
        switch self {
        case .one:
            return UIColor.white
        case .two:
            return UIColor.white
        case .three:
            return UIColor.white
        case .four:
            return UIColor.white
        case .five:
            return UIColor.white
        case .six:
            return UIColor.white
        case .seven:
            return UIColor.white
        case .eight:
            return UIColor.white
        }
    }
}

// class TagList: Object {
//    @Persisted var tagList: List<Tag>
//
//    convenience init(tagList: List<Tag>) {
//        self.init()
//        self.tagList = tagList
//    }
//
//    func addTag(name: String, color: String) {
//        tagList.append(Tag(tagName: name, tagColor: color, position: ))
//    }
//
//    func removeTag(name: String) {
//        guard let tagIndex = tagList.firstIndex(where: { $0.tagName == name }) else { return }
//        tagList.remove(at: tagIndex)
//    }
// }

class Tag: Object {
    @Persisted(primaryKey: true) var tagName: String
    @Persisted var tagColor: String
    @Persisted var position: Int

    convenience init(tagName: String, tagColor: String, position: Int) {
        self.init()
        self.tagName = tagName
        self.tagColor = tagColor
        self.position = position
    }
}
