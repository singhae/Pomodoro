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
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    private let ellipseButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
        $0.backgroundColor = .pomodoro.background
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    private let tagsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private lazy var tagSettingCompletedButton = PomodoroConfirmButton(title: "설정 완료", didTapHandler: didTapSettingCompleteButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        navigationController?.isNavigationBarHidden = false
        
        configureNavigationBar()
        setupViews()
        addTagsToStackView()
    }
    
    private func setupViews() {
        view.backgroundColor = .pomodoro.background
        view.addSubview(horizontalStackView)
        view.addSubview(tagSettingCompletedButton)
        view.addSubview(tagsStackView)
        view.addSubview(tagSettingCompletedButton)
        
        horizontalStackView.addArrangedSubview(label)
        horizontalStackView.addArrangedSubview(ellipseButton)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
  
        tagsStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(view.bounds.height * 0.1)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        tagSettingCompletedButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
        }
    }

    
    private func addTagsToStackView() {
        let buttonTitlesAndColors = [("명상", UIColor.red), ("운동", UIColor.green), ("공부", UIColor.purple),
                                     ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray)]
        let tagsPerRow = [2, 3, 2]
        var currentIndex = 0
        
        tagsPerRow.forEach { count in
            let rowStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 10
                $0.alignment = .fill
                $0.distribution = .fillEqually
            }
            
            for _ in 0..<count {
                let (title, color) = buttonTitlesAndColors[currentIndex % buttonTitlesAndColors.count]
                let button = createRoundButton(title: title, color: color)
                rowStackView.addArrangedSubview(button)
                currentIndex += 1
            }
            
            tagsStackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func createRoundButton(title: String, color: UIColor) -> UIButton {
        return UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.backgroundColor = color
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 40
            $0.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 80, height: 80))
            }
            $0.addTarget(self, action: #selector(configureTag), for: .touchUpInside)
        }
    }
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func configureTag() {
        let configureTagViewController = TagConfigurationViewController()
        configureTagViewController.modalPresentationStyle = .overCurrentContext
        present(configureTagViewController, animated: true, completion: nil)
    }
    
    @objc private func didTapSettingCompleteButton() {
        tagSettingCompletedButton.isEnabled.toggle()
        dismiss(animated: true)
    }
}

// MARK: - TagCreationDelegate
extension TagModalViewController: TagCreationDelegate {
    func createTag(tag: String) {
        TagCollectionViewData.data.append(tag)
        // TODO: 추가된 태그 정보값 전달
    }
}

