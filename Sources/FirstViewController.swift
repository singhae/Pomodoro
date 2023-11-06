//
//  FirstViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit
import Then

class FirstViewController: UIViewController {

    private let label = UILabel().then { label in
        label.text = " 1 "
        label.textColor = .black
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        labelConstrain()
    }
    private func labelConstrain(){
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }

}
