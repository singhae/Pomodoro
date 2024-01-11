//
//  LongBreakModalViewController.swift
//  Pomodoro
//
//  Created by 김현기 on 1/11/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import Foundation
import UIKit

class LongBreakModalViewController: UIViewController {

    let label = UILabel().then {
        $0.text = "Long Break"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)

        setupConstraints()
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
