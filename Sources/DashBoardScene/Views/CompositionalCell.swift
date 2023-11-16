//
//  CompositionalCell.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class FirstCell: UICollectionViewCell {
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "첫 번째 레이아웃"
    }
    private func setupLabel() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("이 생성자를 사용하려면 스토리보드를 구현해주세요.")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLabel)
        self.layer.cornerRadius = 20
        self.backgroundColor = .black
        setupLabel()
    }
}

final class SecondCell: UICollectionViewCell {
    let label = UILabel().then {
        $0.textColor = .black
        $0.text = "두 번째 레이아웃"
    }
    private func setupLabel() {
        self.label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.label)
        self.backgroundColor = .systemGray3
        self.layer.cornerRadius = 20
        setupLabel()
    }
}


