//
//  WeekViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import UIKit

final class WeekViewController: DashboardBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardDateType = .week
        view.backgroundColor = .white
    }
}
