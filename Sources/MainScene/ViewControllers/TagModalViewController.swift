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
//
//final class TagModalViewController: UIViewController {
//    private let dataSource = TagCollectionViewData.data
//    
//    private weak var selectionDelegate: TagModalViewControllerDelegate?
//    
//    private func configureNavigationBar() {
//        navigationItem.title = "태그 설정"
//        let dismissButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .close, target: self, action: #selector(dismissModal)
//        )
//        navigationItem.leftBarButtonItem = dismissButtonItem
//    }
//    
//    private let horizontalStackView = UIStackView().then {
//        $0.axis = .horizontal
//        $0.spacing = 10
//        $0.alignment = .center
//        $0.distribution = .equalSpacing
//    }
//    
//    private let label = UILabel().then {
//        $0.text = "나의 태그"
//        $0.textColor = .black
//        $0.font = UIFont.boldSystemFont(ofSize: 10)
//    }
//    
//    private let ellipseButton = UIButton().then {
//        $0.setImage(UIImage(systemName: "line.horizontal.3"), for: .normal)
//        $0.contentMode = .scaleAspectFit
//        $0.tintColor = .black
//        $0.backgroundColor = .pomodoro.background
//        $0.layer.cornerRadius = 10
//        $0.clipsToBounds = true
//    }
//    
//    private let tagsStackView = UIStackView().then {
//        $0.axis = .vertical
//        $0.spacing = 16
//        $0.alignment = .center
//        $0.distribution = .equalSpacing
//    }
//    
//    private lazy var tagSettingCompletedButton = UIButton().then {
//        $0.setTitle("설정 완료", for: .normal)
//        $0.setTitleColor(.black, for: .normal)
//    }
//    
//    @objc private func dismissModal() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc private func didTapSettingCompleteButton() {
//        let selectedTag = "선택된 태그"
//        selectionDelegate?.tagSelected(tag: selectedTag)
//        dismiss(animated: true)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .pomodoro.background
//        navigationController?.isNavigationBarHidden = false
//        configureNavigationBar()
//        setupLayout()
//        
//        tagSettingCompletedButton.addTarget(self,
//                                            action: #selector(didTapSettingCompleteButton),
//                                            for: .touchUpInside)
//    }
//    
//    private func setupLayout() {
//        view.addSubview(horizontalStackView)
//        view.addSubview(tagsStackView)
//        view.addSubview(tagSettingCompletedButton)
//        
//        horizontalStackView.addArrangedSubview(label)
//        horizontalStackView.addArrangedSubview(ellipseButton)
//        
//        horizontalStackView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.9)
//        }
//        
//        tagsStackView.snp.makeConstraints { make in
//            make.top.equalTo(horizontalStackView.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.8)
//        }
//        
////        let tagsPerRow = [2, 3, 2]
////        tagsPerRow.forEach { numberOfTags in
////            tagsStackView.addArrangedSubview(createRowStackView(numberOfTags: numberOfTags))
////        }
//        
//        tagSettingCompletedButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
//        }
//    }
//    
////        private func createRowStackView(numberOfTags: Int) -> UIStackView {
////            let buttonTitlesAndColors = [("명상", UIColor.red), ("운동", UIColor.green), ("공부", UIColor.purple),
////                                         ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray)]
////            
////            var currentIndex = 0
////            
////            return UIStackView().then {
////                $0.axis = .horizontal
////                $0.spacing = 10
////                $0.alignment = .center
////                $0.distribution = .fillEqually
////    
//////                for _ in 0..<numberOfTags {
//////                    $0.addArrangedSubview(createRoundButton(title: "태그"))
//////                }
////            }
////            for _ in 0..<numberOfTags{
////                let (title, color) = buttonTitlesAndColors[currentIndex % buttonTitlesAndColors.numberOfTags]
////                let button = createRoundButton(title: title, color: color)
////                rowStackView.addArrangedSubview(button)
////                currentIndex += 1
////            }
////        }
//    
//   // private func addTagsToStackView() {
//    private func createRowStackView() {
//        //TODO: 하드코딩한거 수정
//        let buttonTitlesAndColors = [("명상", UIColor.red), ("운동", UIColor.green), ("공부", UIColor.purple),
//                                     ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray), ("+", UIColor.gray)]
//        let tagsPerRow = [2, 3, 2]
//        var currentIndex = 0
//        
//        tagsPerRow.forEach { count in
//            let rowStackView = UIStackView().then {
//                $0.axis = .horizontal
//                $0.spacing = 10
//                $0.alignment = .fill
//                $0.distribution = .fillEqually
//            }
//            
//            for _ in 0..<count {
//                let (title, color) = buttonTitlesAndColors[currentIndex % buttonTitlesAndColors.count]
//                let button = createRoundButton(title: title, color: color)
//                rowStackView.addArrangedSubview(button)
//                currentIndex += 1
//            }
//            
//            tagsStackView.addArrangedSubview(rowStackView)
//        }
//    }
//    
//    //TODO: 사이즈 더 키울 것
//    private func createRoundButton(title: String, color: UIColor) -> UIButton{
//        return UIButton().then {
//            $0.setTitle(title, for: .normal)
//            //$0.backgroundColor = .systemBlue
//            $0.setTitleColor(.white, for: .normal)
//            $0.layer.cornerRadius = 30
//            $0.clipsToBounds = true
//            
//            $0.snp.makeConstraints {
//                $0.size.equalTo(CGSize(width: 60, height: 60))
//            }
//            $0.addTarget(self, action: #selector(configureTag), for: .touchUpInside)
//        }
//    }
//        
//    @objc func configureTag() {
//        let configureTagViewController = TagConfigurationViewController()
//        configureTagViewController.modalPresentationStyle = .overCurrentContext
//        present(configureTagViewController, animated: true, completion: nil)
//    }
//    //TODO: 버튼 클릭시 텍스트필드 팝업
//    private func popTagInput(){
//        
//    }
//}


final class TagModalViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        setupTagsStackView()
        addTagsToStackView()
        
    }
    
    

    private func setupTagsStackView() {
        view.addSubview(tagsStackView)
        
        tagsStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    private func addTagsToStackView() {
        // 버튼의 타이틀과 배경 색상을 정의합니다.
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
            $0.layer.cornerRadius = 30
            $0.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 60, height: 60))
            }
        }
    }
        @objc private func dismissModal() {
            dismiss(animated: true, completion: nil)
        }

}


// MARK: - TagCreationDelegate
extension TagModalViewController: TagCreationDelegate {
    func createTag(tag: String) {
        TagCollectionViewData.data.append(tag)
        // TODO: 추가된 태그 정보값 전달
    }
}
