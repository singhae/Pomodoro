//
//  WeekViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit

final class WeekViewController: UIViewController {
    private let label = UILabel().then { label in
        label.text = "WeekViewController"
        label.textColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
    }
    
    private func setupLabel(){
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
