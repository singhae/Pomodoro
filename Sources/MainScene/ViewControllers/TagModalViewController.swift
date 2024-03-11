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

protocol TagModalViewControllerDelegate: AnyObject {
    func tagSelected(tag: String)
}

final class TagModalViewController: UIViewController {
    private let dataSource = TagCollectionViewData.data

    private weak var selectionDelegate: TagModalViewControllerDelegate?

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

    private let tagsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    private lazy var tagSettingCompletedButton = UIButton().then {
        $0.setTitle("설정 완료", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapSettingCompleteButton() {
        let selectedTag = "선택된 태그"
        selectionDelegate?.tagSelected(tag: selectedTag)
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        navigationController?.isNavigationBarHidden = false
        configureNavigationBar()
        setupLayout()

        tagSettingCompletedButton.addTarget(self,
                                            action: #selector(didTapSettingCompleteButton),
                                            for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(horizontalStackView)
        view.addSubview(tagsStackView)
        view.addSubview(tagSettingCompletedButton)

        horizontalStackView.addArrangedSubview(label)
        horizontalStackView.addArrangedSubview(ellipseButton)

        tagsStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        let tagsPerRow = [2, 3, 2]
        tagsPerRow.forEach { numberOfTags in
            tagsStackView.addArrangedSubview(createRowStackView(numberOfTags: numberOfTags))
        }

        tagSettingCompletedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
        }
    }

    private func createRowStackView(numberOfTags: Int) -> UIStackView {
        return UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .center
            $0.distribution = .fillEqually
            
            for _ in 0..<numberOfTags {
                $0.addArrangedSubview(createRoundButton(title: "태그"))
            }
        }
    }
    
    private func createRoundButton(title: String) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 30
            $0.clipsToBounds = true
            
            $0.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 60, height: 60))
            }
        }
    }
}

// MARK: - TagCreationDelegate
extension TagModalViewController: TagCreationDelegate {
    func createTag(tag: String) {
        TagCollectionViewData.data.append(tag)
        // TODO: 추가된 태그 정보값 전달
    }
}
