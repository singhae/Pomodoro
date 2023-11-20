//
//  MainViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import Then
import UIKit
import PanModal

final class MainViewController: UIViewController {

    private var timer: Timer?
    private var stopLongPress: UILongPressGestureRecognizer!

    private var notificationId: String?

    private var currentTime = 0
    private var maxTime = 0

    private let timeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
    }

    private let tagLabel = UILabel().then {
        $0.text = "Tag 위치는 여기쯤?"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    private let longPressLabel = UILabel().then {
        $0.text = "길게 클릭해서 타이머를 정지할 수 있어요"
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isHidden = true
    }

    private let timeButton = UIButton(type: .roundedRect).then {
        $0.setTitle("시간 설정", for: .normal)
        $0.addTarget(self, action: #selector(timeSetting), for: .touchUpInside)
    }

    private let countButton = UIButton(type: .roundedRect).then {
        $0.setTitle("카운트 시작", for: .normal)
        $0.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    }

    @objc private func timeSetting() {
        let alertController = UIAlertController(title: "시간 설정", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "시간을 입력하세요"
            textField.keyboardType = .numberPad
        }
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alertController.textFields?.first?.text, let time = Int(text) {
                self.maxTime = time
                self.currentTime = 0

                let minutes = (self.maxTime - self.currentTime) / 60
                let seconds = (self.maxTime - self.currentTime) % 60
                self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            } else {}
        }
        alertController.addAction(confirm)
        present(alertController, animated: true)
    }

    @objc private func stopTimer() {
        timer?.invalidate()
        currentTime = 0
        maxTime = 0

        let minutes = (maxTime - currentTime) / 60
        let seconds = (maxTime - currentTime) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)

        if let id = notificationId {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }

        countButton.isHidden = false
        timeButton.isHidden = false
        longPressLabel.isHidden = true
    }

    @objc private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let minutes = (self.maxTime - self.currentTime) / 60
            let seconds = (self.maxTime - self.currentTime) % 60
            self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            self.currentTime += 1

            if self.currentTime > self.maxTime {
                timer.invalidate()
                self.countButton.isHidden = false
                self.timeButton.isHidden = false
                self.longPressLabel.isHidden = true
            }
        }
        timer?.fire()

        notificationId = UUID().uuidString

        let content = UNMutableNotificationContent()
        content.title = "시간 종료!"
        content.body = "시간이 종료되었습니다. 휴식을 취해주세요."

        let request = UNNotificationRequest(
            identifier: notificationId!,
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
        countButton.isHidden = true
        timeButton.isHidden = true
        longPressLabel.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(timeLabel)
        view.addSubview(tagLabel)
        view.addSubview(longPressLabel)
        view.addSubview(countButton)
        view.addSubview(timeButton)
        setupTimeLabel()
        setupTagLabel()
        setupLongPressLabel()
        setupButtons()

        stopLongPress = UILongPressGestureRecognizer(target: self, action: #selector(stopTimer))
        view.addGestureRecognizer(stopLongPress)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let minutes = (maxTime - currentTime) / 60
        let seconds = (maxTime - currentTime) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        // MARK: Modal
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            let modalViewController = TagModalViewController()
            modalViewController.modalPresentationStyle = .fullScreen
            self.presentPanModal(modalViewController)
        })
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

    private func setupLongPressLabel() {
        longPressLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-30)
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

extension TagModalViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 0.4)
    }
}

