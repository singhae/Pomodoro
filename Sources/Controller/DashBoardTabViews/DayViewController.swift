//
//  DashBoardTabView.swift
//  Pomodoro
//
//  Created by 김하람 on 2023/11/13.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit

final class DayViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDateLabel()
        setupArrowButtons()
        setupCollectionView()
    }
    
    private let dateLabel = UILabel().then {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = .none
        $0.text = dateFormatter.string(from: Date())
        $0.textAlignment = .center
        $0.textColor = .black
    }
    private func setupDateLabel() {
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private let previousButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
    }
    private let nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.right")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
    }
    private func setupArrowButtons() {
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        previousButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.trailing.equalTo(dateLabel.snp.leading).offset(-10)
        }
        nextButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
        }
    }
    static func getLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            
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
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: DayViewController.getLayout()).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.clipsToBounds = true
        $0.register(FirstCell.self, forCellWithReuseIdentifier: "FirstCell")
        $0.register(SecondCell.self, forCellWithReuseIdentifier: "SecondCell")
    }
    private let dataSource: [MySection] = [
        .first([
            MySection.FirstItem(value: "첫 레이아웃"),
        ]),
        .second([
            MySection.SecondItem(value: "두 번째 레이아웃"),
        ])
    ]
    
    private func setupCollectionView () {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom)
        }
        self.collectionView.dataSource = self
    }
}

extension DayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .first(items):
            return items.count
        case let .second(items):
            return items.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.dataSource[indexPath.section] {
        case .first(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCell", for: indexPath) as? FirstCell else {
                return UICollectionViewCell()
            }
            return cell
        case .second(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCell", for: indexPath) as? SecondCell else {
                return UICollectionViewCell()
            }
            return cell
        }
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
