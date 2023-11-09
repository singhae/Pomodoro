//
//  MainViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import UIKit

final class MainViewController: UIViewController {

    private var timer: Timer?

    private var currentTime = 0
    private var maxTime = 0

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
        return label
    }()

    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "Tag 위치는 여기쯤?"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private let timeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("시간 설정", for: .normal)
        button.addTarget(self, action: #selector(timeSetting), for: .touchUpInside)
        return button
    }()

    // 임시
    private let countButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("카운트 시작", for: .normal)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        return button
    }()

    @objc private func timeSetting() {
        let alertController = UIAlertController(title: "시간 설정", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "시간을 입력하세요"
            textField.keyboardType = .numberPad
        }
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alertController.textFields?.first?.text, let time = Int(text) {
                print(time)
                self.maxTime = time
                self.currentTime = 0

                let minutes = (self.maxTime - self.currentTime) / 60
                let seconds = (self.maxTime - self.currentTime) % 60
                self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            } else {
                print("No Time")
            }
        }
        alertController.addAction(confirm)
        present(alertController, animated: true)
        print("alert")
    }

    @objc private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("currentTime: " + String(self.currentTime))

            let minutes = (self.maxTime - self.currentTime) / 60
            let seconds = (self.maxTime - self.currentTime) % 60
            self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            self.currentTime += 1

            if self.currentTime > self.maxTime {
                timer.invalidate()
            }

        }
        timer?.fire()

        let content = UNMutableNotificationContent()
        content.title = "시간 종료!"
        content.body = "시간이 종료되었습니다. 휴식을 취해주세요."
        content.sound = .default
        content.badge = 99
        content.userInfo = ["destination": "dashboard"]

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(maxTime),
                repeats: false
            )
        )

        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error = error else { return }
                print(error.localizedDescription)
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(timeLabel)
        view.addSubview(tagLabel)
        view.addSubview(countButton)
        view.addSubview(timeButton)
        setupTimeLabel()
        setupTagLabel()
        setupButtons()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let minutes = (maxTime - currentTime) / 60
        let seconds = (maxTime - currentTime) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func setupTimeLabel() {
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.67)
        }
    }

    private func setupTagLabel() {
        tagLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
    }

    private func setupButtons() {
        timeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-50)
        }
        countButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(timeButton.snp.top).offset(-50)
        }
    }
}
