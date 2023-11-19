import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let project = Project.app(
    name: "Pomodoro",
    platform: .iOS,
    additionalTargets: [
        .external(name: "Then"),
        .external(name: "SnapKit"),
        .external(name: "Realm"),
        .external(name: "DGCharts"),
        .external(name: "PanModal")
    ]
)
