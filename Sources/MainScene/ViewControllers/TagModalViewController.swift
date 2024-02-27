//
//  TagModalViewController.swift
//  Pomodoro
//
//  Created by SonSinghae on 2023/11/17.
//  Copyright © 2023 io.hgu. All rights reserved.
//
import PomodoroDesignSystem
import SnapKit
import Then
import UIKit

protocol TagCreationDelegate: AnyObject {
    func createTag(tag: String)
}

protocol TagSelectionDelegate: AnyObject {
    func tagSelected(tag: String)
}

//TODO: - 뒤 화면 축소되는 효과 제거

final class TagModalViewController: UIViewController, UICollectionViewDelegate {
    private var tagCollectionView: TagCollectionView?
    private let dataSource = TagCollectionViewData.data
    private var tagList = TagList()

    private weak var selectionDelegate: TagSelectionDelegate?

    private func configureNavigationBar() {
        navigationItem.title = "태그 설정"
        let dismissButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(dismissModal)
        )
        navigationItem.leftBarButtonItem = dismissButtonItem
    }

    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    private let label = UILabel().then {
        $0.text = "나의 태그"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 10)
    }

    private let ellipseButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
        $0.backgroundColor = .pomodoro.background
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
    }

    private lazy var timeSettingbutton = UIButton().then {
        $0.setTitle("설정 완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    // MARK: - 삭제 기능(+ 버튼)

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func ellipseButtonTapped() {}

    @objc private func didTapSettingCompleteButton() {
        let selectedTag = "선택된 태그"
        selectionDelegate?.tagSelected(tag: selectedTag)
        dismiss(animated: true) {
        let mainViewController = MainViewController()
            self.navigationController?.pushViewController(mainViewController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        navigationController?.isNavigationBarHidden = false
        configureNavigationBar()
        configureCollectionView()
        registerCollectionView()
        configureCollectionViewDelegate()
        configureLayout()

        timeSettingbutton.addTarget(self, action: #selector(didTapSettingCompleteButton), for: .touchUpInside)
    }

    private func configureLayout() {
        horizontalStackView.addArrangedSubview(label)
        horizontalStackView.addArrangedSubview(ellipseButton)
        mainStackView.addArrangedSubview(horizontalStackView)
        
        if let tagCollectionView {
            mainStackView.addArrangedSubview(tagCollectionView)
        }
        view.addSubview(mainStackView)
        
        view.addSubview(timeSettingbutton)

        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        timeSettingbutton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
        }
    }

    private func configureCollectionView() {
        let collectionViewLayer = UICollectionViewFlowLayout()
        collectionViewLayer.sectionInset = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
        collectionViewLayer.minimumLineSpacing = 5
        collectionViewLayer.minimumInteritemSpacing = 1

        let tagCollectionView = TagCollectionView(frame: .zero, collectionViewLayout: collectionViewLayer)
        tagCollectionView.backgroundColor = .pomodoro.background

        view.addSubview(tagCollectionView)

        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(120)
            make.left.right.bottom.equalToSuperview().inset(40)
        }
        self.tagCollectionView = tagCollectionView
    }

    private func registerCollectionView() {
        tagCollectionView?.register(
            TagCollectionViewCell.self,
            forCellWithReuseIdentifier: TagCollectionViewCell.id
        )
    }

    private func configureCollectionViewDelegate() {
        tagCollectionView?.dataSource = self
        tagCollectionView?.delegate = self
    }
}

extension TagModalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 10
        let totalPadding = padding * (2 - 1)
        let individualPadding = totalPadding / 2
        let width = (collectionView.bounds.width - totalPadding) / 2
        let height: CGFloat = 70
        return CGSize(width: width - individualPadding, height: height)
    }

    func collectionView(
        _: UICollectionView,
        numberOfItemsInSection _: Int
    ) -> Int {
        tagList.tagList.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCollectionViewCell.id,
            for: indexPath
        ) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }

        let tag = tagList.tagList[indexPath.item]
        cell.configureWithTag(tag)

        return cell
    }

    func collectionView(
        _: UICollectionView,
        didSelectItemAt _: IndexPath
    ) {
        let tagConfigView = TagConfigurationViewController()
        tagConfigView.delegate = self
        present(tagConfigView, animated: true, completion: nil)
    }
}

extension TagModalViewController: TagCreationDelegate {
    func createTag(tag: String) {
        TagCollectionViewData.data.append(tag)
        // TODO: 추가된 태그 정보값 전달
        
    }
}
