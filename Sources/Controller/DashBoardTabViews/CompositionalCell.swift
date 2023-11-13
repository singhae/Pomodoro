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

func getLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
        
        func makeItem() -> NSCollectionLayoutItem {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemInset: CGFloat = 3.0
            item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
            item.contentInsets.leading = 15
            item.contentInsets.trailing = 15
            item.contentInsets.top = 15
            
            return item
        }
        
        func makeGroup(heightFraction: CGFloat) -> NSCollectionLayoutGroup {
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(heightFraction)
            )
            return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [makeItem()])
        }
        
        switch section {
        case 0:
            return NSCollectionLayoutSection(group: makeGroup(heightFraction: 1.0 / 3.0))
        default:
            return NSCollectionLayoutSection(group: makeGroup(heightFraction: 1.0 / 2.0))
        }
    }
}

final class FirstCell: UICollectionViewCell {
    let label = UILabel().then {
        $0.textColor = .white
        $0.text = "첫 번째 레이아웃"
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        self.layer.cornerRadius = 20
        self.backgroundColor = .black
        setupLabel()
    }
}

final class SecondCell: UICollectionViewCell {
    let label = UILabel().then {
        $0.textColor = .black
        $0.text = "두 번째 레이아웃"
        $0.translatesAutoresizingMaskIntoConstraints = false
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

enum MySection {
    case first([FirstItem])
    case second([SecondItem])
    
    struct FirstItem {
        let value: String
    }
    struct SecondItem {
        let value: String
    }
}
