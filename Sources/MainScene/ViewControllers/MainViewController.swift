//
//  MainViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import PanModal
import SnapKit
import Then
import UIKit

final class MainViewController: UIViewController {
    private var timer: Timer?
    private var notificationId: String?
    private var longPressTimer: Timer?
    private var longPressTime: Float = 0.0

    let pomodoroTimeManager = PomodoroTimeManager.shared

    private let timeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 60, weight: .heavy)
    }

    private let longPressGuideLabel = UILabel().then {
        $0.text = "길게 클릭해서 타이머를 정지할 수 있어요"
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isHidden = true
    }

    private let progressBar = UIProgressView().then {
        $0.progressViewStyle = .default
        $0.trackTintColor = .lightGray
        $0.progressTintColor = .systemBlue
        $0.progress = 0.0
        $0.isHidden = true
    }

    private lazy var tagButton = UIButton().then {
        $0.setTitle("Tag", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.addTarget(
            self,
            action: #selector(openTagModal),
            for: .touchUpInside
        )
    }

    private lazy var countButton = UIButton(type: .roundedRect).then {
        $0.setTitle("카운트 시작", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    }

    private lazy var timeButton = UIButton(type: .roundedRect).then {
        $0.setTitle("시간 설정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(timeSetting), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()

        print("Current: \(pomodoroTimeManager.currentTime), Max: \(pomodoroTimeManager.maxTime)")
        if pomodoroTimeManager.maxTime > pomodoroTimeManager.currentTime {
            updateTimeLabel()
            startTimer()
        }

        setupLongPress(isEnable: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTimeLabel()
        // FIXME: Remove startTimer() after implementing time setup
    }

    private func updateTimeLabel() {
        let minutes = (pomodoroTimeManager.maxTime - pomodoroTimeManager.currentTime) / 60
        let seconds = (pomodoroTimeManager.maxTime - pomodoroTimeManager.currentTime) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)

        if let id = notificationId {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }
}

// MARK: - Action

extension MainViewController {
    @objc private func openTagModal() {
        let modalViewController = TagModalViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        presentPanModal(modalViewController)
    }

    private func setupLongPress(isEnable: Bool) {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress)
        )
        longPressGestureRecognizer.isEnabled = isEnable
        longPressGestureRecognizer.allowableMovement = .infinity
        longPressGestureRecognizer.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        progressBar.isHidden = false

        longPressTimer?.invalidate()
        longPressTimer = Timer.scheduledTimer(timeInterval: 0.02,
                                              target: self,
                                              selector: #selector(setProgress),
                                              userInfo: nil,
                                              repeats: true)
        longPressTimer?.fire()

        if gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended {
            progressBar.isHidden = true
            longPressTime = 0.0
            progressBar.progress = 0.0

            longPressTimer?.invalidate()
        }
    }

    @objc private func setProgress() {
        longPressTime += 0.02
        progressBar.setProgress(longPressTime, animated: true)

        if longPressTime >= 1 {
            longPressTime = 0.0
            progressBar.progress = 0.0

            longPressTimer?.invalidate()

            progressBar.isHidden = true
            stopTimer()
        }
    }

    @objc private func stopTimer() {
        timer?.invalidate()
        pomodoroTimeManager.currentTime = 0
        pomodoroTimeManager.maxTime = 0
        updateTimeLabel()
        longPressGuideLabel.isHidden = true
        countButton.isHidden = false
        timeButton.isHidden = false
    }

    @objc private func timeSetting() {
        let timeSettingviewController = TimeSettingViewController(isSelectedTime: false, delegate: self)
        navigationController?.pushViewController(timeSettingviewController, animated: true)
    }

    @objc private func startTimer() {
        print("CurrentTime: \(pomodoroTimeManager.currentTime), MaxTime: \(pomodoroTimeManager.maxTime)")
        longPressTime = 0.0
        progressBar.progress = 0.0

        setupLongPress(isEnable: true)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.longPressGuideLabel.isHidden = false
            self.countButton.isHidden = true
            self.timeButton.isHidden = true

            if self.pomodoroTimeManager.currentTime > self.pomodoroTimeManager.maxTime {
                timer.invalidate()
                self.longPressGuideLabel.isHidden = true
                self.countButton.isHidden = false
                self.timeButton.isHidden = false
                let breakVC = BreakViewController()
                self.navigationController?.pushViewController(breakVC, animated: true)
            }
            self.pomodoroTimeManager.currentTime += 1

            let minutes = (self.pomodoroTimeManager.maxTime - self.pomodoroTimeManager.currentTime) / 60
            let seconds = (self.pomodoroTimeManager.maxTime - self.pomodoroTimeManager.currentTime) % 60

            self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
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
                timeInterval: TimeInterval(pomodoroTimeManager.maxTime),
                repeats: false
            )
        )

        UNUserNotificationCenter.current()
            .add(request) { error in
                guard let error else { return }
                print(error.localizedDescription)
            }
    }
}

// MARK: - UI

extension MainViewController {
    private func addSubviews() {
        view.addSubview(countButton)
        view.addSubview(timeLabel)
        view.addSubview(tagButton)
        view.addSubview(timeButton)
        view.addSubview(longPressGuideLabel)
        view.addSubview(progressBar)
    }

    private func setupConstraints() {
        tagButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
        longPressGuideLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-30)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.67)
        }
        timeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-50)
        }
        countButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(timeButton.snp.top).offset(-50)
        }
        progressBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(longPressGuideLabel).offset(-50)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}

extension TagModalViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 0.4)
    }
}

extension MainViewController: TimeSettingViewControllerDelegate {
    func didSelectTime(time: Int) {
        pomodoroTimeManager.maxTime = time * 60
    }
}
