//
//  TimerCollectionViewCell.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/12/27.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import Then
import UIKit

class TimerCollectionViewCell: UICollectionViewCell {
    let timeLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    }

    private let timeSelectionImage = UIImageView().then {
        $0.isHidden = true
        $0.image = UIImage(systemName: "arrowtriangle.up.fill")
        $0.tintColor = .black
    }

    private let timeCircleView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.masksToBounds = true
    }

    var isSelectedTime: Bool = false {
        didSet {
            timeSelectionImage.isHidden = !isSelectedTime
            timeCircleView.backgroundColor = isSelectedTime ? .black : .systemGray
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        timeCircleView.layer.cornerRadius = timeCircleView.bounds.width / 2
    }

    private func setupViews() {
        addSubview(timeLabel)
        addSubview(timeSelectionImage)
        addSubview(timeCircleView)

        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top).offset(9.0)
        }

        timeSelectionImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).offset(15.0)
        }

        timeCircleView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(self.snp.width).multipliedBy(0.7)
        }
    }
}
