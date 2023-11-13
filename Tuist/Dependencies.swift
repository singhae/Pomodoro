//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 전여훈 on 2023/11/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote( // Realm
            url: "https://github.com/realm/realm-swift.git",
            requirement: .upToNextMajor(from: "10.28.2")
        ),
        .remote( // Then
            url: "https://github.com/devxoul/Then.git",
            requirement: .upToNextMajor(from: "2")
        ),
        .remote( // SnapKit
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.6.0")
        ),
        .remote( // DPCharts 
            url: "https://github.com/danielepantaleone/DPCharts.git",
            requirement: .upToNextMajor(from: "1.2.2")
        ),
    ],
    platforms: [.iOS]
)
