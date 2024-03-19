//
//  BreakViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2/19/24.
//

import UIKit

final class BreakViewController: UIViewController {
    private let appIconStackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.primary900
        setUI()
    }

    private func setUI() {
        let logoIcon = UIImageView().then {
            $0.image = UIImage(named: "breakLogo")
        }
        let appName = UILabel().then {
            $0.text = "뽀모도로"
            $0.textColor = .pomodoro.background
            $0.font = .pomodoroFont.text1(size: 15.27)
        }

        appIconStackView.then {
            view.addSubview($0)
            $0.addArrangedSubview(logoIcon)
            $0.addArrangedSubview(appName)
            $0.spacing = 5
            $0.axis = .horizontal
            $0.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.leading.equalTo(30)
            }
        }
        let breakButton = UIButton().then {
            view.addSubview($0)
            $0.setTitle("휴식시간\n시작하기", for: .normal)
            $0.titleLabel?.numberOfLines = 0
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .pomodoroFont.heading1()
            $0.addTarget(self, action: #selector(breakButtonTapped), for: .touchUpInside)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
    }

    @objc func breakButtonTapped() {
        let breakTimeVC = BreakTimerViewController()
        navigationController?.pushViewController(breakTimeVC, animated: true)
    }
}
