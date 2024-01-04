//
//  TimeSettingViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/12/21.
//  Copyright © 2023 io.hgu. All rights reserved.

import SnapKit
import Then
import UIKit

protocol TimeSettingViewControllerDelegate: AnyObject {
    func didSelectTime(time: Int)
}

final class TimeSettingViewController: UIViewController {
    private var isSelectedTime: Bool = false
    private let colletionViewIdentifier = "TimerCollectionViewCell"
    private var centerIndexPath: IndexPath?
    private var selectedTime: Int = 0

    private weak var delegate: TimeSettingViewControllerDelegate?

    init(
        isSelectedTime: Bool,
        heightProportionForMajorCell _: CGFloat? = nil,
        centerIndexPath: IndexPath? = nil,
        delegate: TimeSettingViewControllerDelegate? = nil
    ) {
        self.isSelectedTime = isSelectedTime
        self.centerIndexPath = centerIndexPath
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var timeSettingbutton = UIButton().then {
        $0.setTitle("설정 완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }

    private var titleTime = UILabel().then {

        $0.font = UIFont.systemFont(ofSize: 40.0, weight: .bold)
        $0.textAlignment = .center
    }

    private let collectionFlowlayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionFlowlayout
    ).then {
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = true
        $0.register(TimerCollectionViewCell.self, forCellWithReuseIdentifier: colletionViewIdentifier)
        $0.showsHorizontalScrollIndicator = false
        let padding = view.bounds.width / 2 - collectionFlowlayout.itemSize.width / 2
        $0.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        setUpLayout()
    }

    private func setUpLayout() {
        view.addSubview(collectionView)
        view.addSubview(titleTime)
        view.addSubview(timeSettingbutton)

        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.3))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }

        titleTime.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.bounds.height * 0.2)
            make.centerX.equalToSuperview()
        }

        timeSettingbutton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-(view.bounds.height * 0.2))
        }
    }

    @objc private func onClick() {
        delegate?.didSelectTime(time: Int(centerIndexPath?.item ?? 0))
        navigationController?.popViewController(animated: true)
    }
}

extension TimeSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        100
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: colletionViewIdentifier,
            for: indexPath
        ) as? TimerCollectionViewCell else {
            return UICollectionViewCell()
        }

        if indexPath.item % 5 == 0 {
            cell.timeLabel.textColor = .black
        } else {
            cell.timeLabel.textColor = .white
        }

        cell.timeLabel.text = "\(Int(indexPath.item))"

        isSelectedTime = indexPath == centerIndexPath
        cell.isSelectedTime = isSelectedTime
        cell.backgroundColor = .white

        return cell
    }
}

extension TimeSettingViewController: UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(
            x: scrollView.contentOffset.x + (scrollView.bounds.width / 2),
            y: scrollView.bounds.height / 2
        )

        guard let centerIndexPathCalculation = collectionView.indexPathForItem(at: center) else {
            return
        }
        let hours = Int(centerIndexPathCalculation.item) / 60
        let minutes = Int(centerIndexPathCalculation.item) % 60
        titleTime.text = String(format: "%02d:%02d", hours, minutes)

        if centerIndexPath != centerIndexPathCalculation {
            centerIndexPath = centerIndexPathCalculation
            collectionView.reloadData()
        }
    }
    
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.item % 5 == 0 {
            return CGSize(width: 75, height: 75)
        } else {
            return CGSize(width: 50, height: 50)
        }
    }
}
