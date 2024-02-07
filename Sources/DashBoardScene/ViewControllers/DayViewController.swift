//
//  DayViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import UIKit

final class DayViewController: DashboardContentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDateLabel()
    }

    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

enum MySection {
    case first([FirstItem])
    case second([SecondItem])

    struct FirstItem {
        let value: String
    }

    struct SecondItem {
        let value: String
    }
}
