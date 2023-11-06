//
//  DashBoardViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit

final class DashBoardViewController: UIViewController {

    private let label = UILabel().then { label in
        label.text = "DashBoardViewController"
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
