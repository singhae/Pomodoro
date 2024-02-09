//
//  YearViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import UIKit

final class YearViewController: DashboardBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardDateType = .year
        view.backgroundColor = .white
    }
}
