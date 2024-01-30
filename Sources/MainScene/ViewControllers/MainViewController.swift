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
    private var currentTime = 0
    private var maxTime = 0
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
    private lazy var countButton = UIButton(type: .roundedRect).then {
        $0.setTitle("카운트 시작", for: .normal)
        $0.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
    }
    
    private lazy var timeButton = UIButton(type: .roundedRect).then {
        $0.setTitle("시간 설정", for: .normal)
        $0.addTarget(self, action: #selector(timeSetting), for: .touchUpInside)
    }
    
    @objc private func timeSetting() {
        
        let timeSettingviewController = TimeSettingViewController(isSelectedTime: false, delegate: self)
        self.navigationController?.pushViewController(timeSettingviewController, animated: true)
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()

        let longPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(stopTimer)
        )
        longPressGestureRecognizer.minimumPressDuration = 3
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTimeLabel()
        // FIXME: Remove startTimer() after implementing time setup
    }

    private func updateTimeLabel() {
        let minutes = (maxTime - currentTime) / 60
        let seconds = (maxTime - currentTime) % 60
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

    @objc private func stopTimer() {
        timer?.invalidate()
        currentTime = 0
        maxTime = 0
        updateTimeLabel()
    }

    @objc private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let minutes = (self.maxTime - self.currentTime) / 60
            let seconds = (self.maxTime - self.currentTime) % 60
            
            self.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
            self.currentTime += 1

            if self.currentTime > self.maxTime {
                timer.invalidate()
            }
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
        maxTime = time * 60
    }
}
