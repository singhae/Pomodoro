//
//  DataResetModalViewController.swift
//  Pomodoro
//
//  Created by 김현기 on 1/18/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import Foundation
import UIKit

final class DataResetModalViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.text = "데이터 초기화 하기"
        $0.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    }

    private let contentLabel = UILabel().then {
        $0.text = "데이터를 초기화 하시겠습니까? 태그, 뽀모도로 기록 등 모든 데이터와 설정이 초기화됩니다."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    private let yesButton = UIButton().then {
        $0.setTitle("예", for: .normal)
        $0.backgroundColor = .systemBlue
    }

    private let noButton = UIButton().then {
        $0.setTitle("아니오", for: .normal)
        $0.backgroundColor = .systemRed
    }

    private var buttonsStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(contentLabel)

        buttonsStack = UIStackView(arrangedSubviews: [yesButton, noButton]).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 20
        }
        view.addSubview(buttonsStack)

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel).offset(80)
            make.width.equalToSuperview().inset(30)
        }
        buttonsStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(50)
            make.width.equalToSuperview().inset(30)
        }
    }
}
