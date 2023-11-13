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
        $0.translatesAutoresizingMaskIntoConstraints = false
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
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let nextButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.right")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: getLayout()).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.clipsToBounds = true
        $0.register(FirstCell.self, forCellWithReuseIdentifier: "FirstCell")
        $0.register(SecondCell.self, forCellWithReuseIdentifier: "SecondCell")
        $0.translatesAutoresizingMaskIntoConstraints = false
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCell", for: indexPath) as! FirstCell
            return cell
        case .second(_):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondCell", for: indexPath) as! SecondCell
            return cell
        }
    }
}
