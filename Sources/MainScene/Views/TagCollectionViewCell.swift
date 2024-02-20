//
//  TagCollectionViewCell.swift
//  Pomodoro
//
//  Created by SonSinghae on 2023/12/31.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import Then
import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    let tagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
        $0.textColor = .white
    }

    var dataLabel = UILabel()

    static var id: String {
        if let className = NSStringFromClass(Self.self).components(separatedBy: ".").last {
            return className
        } else {
            return "DefaultClassName"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(tagLabel)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }

    // FIXME:
    func configureWithTag(_ tag: Tag) {
        dataLabel.text = tag.tagName // 태그 이름 설정
        dataLabel.backgroundColor = tag.tagColor // 태그 색상으로 배경색 설정
    }

    private func configure() {
        dataLabel = UILabel()
        dataLabel.font = UIFont.systemFont(ofSize: 15)
        dataLabel.textColor = .label
        dataLabel.textAlignment = .center
        dataLabel.backgroundColor = .systemIndigo

        contentView.addSubview(dataLabel)

        dataLabel.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
