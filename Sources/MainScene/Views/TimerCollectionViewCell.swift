//
//  TimerCollectionViewCell.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/12/27.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import PomodoroDesignSystem
import SnapKit
import Then
import UIKit

class TimerCollectionViewCell: UICollectionViewCell {
    let timeLabel = UILabel().then {
        $0.textColor = .pomodoro.blackMedium
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16.0, weight: .light)
    }

    private(set) var defualtColor: UIColor = .pomodoro.blackHigh

    func setDefualtColor(color: UIColor) {
        defualtColor = color
    }

    private var heightBar: CGFloat?
    private var widthBar: CGFloat?

    private let timeSelectionImage = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(systemName: "arrowtriangle.up.fill")
        $0.tintColor = .pomodoro.primary900
    }

    private let timeCircleView = UIView().then {
        $0.backgroundColor = .pomodoro.primary200
    }

    var isSelectedTime: Bool = false {
        didSet {
            didChanageCellComponent()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundConfiguration?.backgroundColor = .pomodoro.background
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHeightView(height: CGFloat, widthBar: CGFloat) {
        heightBar = height
        self.widthBar = widthBar
    }

    func didChanageCellComponent() {
        timeSelectionImage.isHidden = !isSelectedTime
        if isSelectedTime {
            timeCircleView.backgroundColor = .pomodoro.primary900
            timeSelectionImage.tintColor = .pomodoro.primary900
            timeLabel.textColor = .pomodoro.primary900
            timeLabel.font = .systemFont(ofSize: 20.0, weight: .semibold)
        } else {
            timeCircleView.backgroundColor = defualtColor
            timeSelectionImage.tintColor = defualtColor
            timeLabel.textColor = .pomodoro.blackMedium
            timeLabel.font = .systemFont(ofSize: 16.0, weight: .light)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        timeCircleView.snp.updateConstraints { make in
            make.height.equalTo(heightBar ?? 0)
            make.width.equalTo(widthBar ?? 0)
        }
    }

    private func setupViews() {
        addSubview(timeLabel)
        addSubview(timeSelectionImage)
        addSubview(timeCircleView)
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        timeSelectionImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(16)
            make.top.equalTo(timeCircleView.snp.bottom).offset(9.0)
        }

        timeCircleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(0)
            make.height.equalTo(0)
        }
    }
}
