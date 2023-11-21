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
    private var currentTimeInSeconds = 0
    private var maxTimeInSeconds = 10 // FIXME: 설정된 값으로 초기화 필요

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

    private let tagButton = UIButton().then {
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

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(stopTimer))
        longPressGestureRecognizer.minimumPressDuration = 3
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTimeLabel()
        // FIXME: Remove startTimer() after implementing time setup
        startTimer()
    }

    private func updateTimeLabel() {
        let minutes = (maxTimeInSeconds - currentTimeInSeconds) / 60
        let seconds = (maxTimeInSeconds - currentTimeInSeconds) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.updateTimeLabel()
            self.currentTimeInSeconds += 1

            if self.currentTimeInSeconds > self.maxTimeInSeconds {
                timer.invalidate()
            }
        }

        self.longPressGuideLabel.isHidden = false
        timer?.fire()
    }
}

// MARK: - Action

extension MainViewController {
    @objc private func openTagModal() {
        let modalViewController = TagModalViewController()
        modalViewController.modalPresentationStyle = .fullScreen
        self.presentPanModal(modalViewController)
    }

    @objc private func stopTimer() {
        timer?.invalidate()
        currentTimeInSeconds = 0
        maxTimeInSeconds = 0
        updateTimeLabel()
        longPressGuideLabel.isHidden = true
    }
}

// MARK: - UI

extension MainViewController {
    private func addSubviews() {
        view.addSubview(timeLabel)
        view.addSubview(tagButton)
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

