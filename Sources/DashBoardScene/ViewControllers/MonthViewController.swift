//
//  MonthViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.

import DGCharts
import SnapKit
import Then
import UIKit

final class MonthViewController: DashboardBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        dashboardDateType = .month
        view.backgroundColor = .white
    }
}
