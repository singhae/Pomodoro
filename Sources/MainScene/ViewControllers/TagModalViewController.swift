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
import RealmSwift

protocol TagCreationDelegate: AnyObject {
    func createTag(tag: String)
}

protocol TagModalViewControllerDelegate: AnyObject {
    func tagSelected(tag: String)
}

final class TagModalViewController: UIViewController {
    // realm database
    let database = DatabaseManager.shared

    private var tags: Results<Tag>?

    private weak var selectionDelegate: TagModalViewControllerDelegate?

    private func configureNavigationBar() {
        navigationItem.title = "태그 설정"
        let dismissButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(dismissModal)
        )
        navigationItem.rightBarButtonItem = dismissButtonItem
    }

    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    private let label = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }

    private lazy var editTagButton = UIButton().then {
        $0.setTitle("Edit", for: .normal)
        $0.titleLabel?.font = .pomodoroFont.heading5()
        $0.setTitleColor(.pomodoro.blackHigh, for: .normal)
        $0.contentMode = .scaleAspectFit
//        $0.tintColor = .black
        $0.backgroundColor = .pomodoro.background
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(createMinusButton), for: .touchUpInside) // 마이너스버튼 생성되는 액션 추가
    }

    private let tagsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    private lazy var tagSettingCompletedButton = PomodoroConfirmButton (
        title: "설정 완료",
        didTapHandler: didTapSettingCompleteButton
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        navigationController?.isNavigationBarHidden = false
        configureNavigationBar()
        setupViews()
        // MARK: 태그 정보 불러오는 메소드 따로 호출
        loadTagsFromDatabase()
        addTagsToStackView()
        tagSettingCompletedButton.isEnabled = false // 첫 화면에는 설정완료 비활성화
        database.getLocationOfDefaultRealm()

        let tags = database.read(Tag.self)
        if tags.isEmpty {
            database.write(
                Tag(
                    tagName: "운동",
                    colorIndex: "one",
                    position: 1
                )
            )
        }
    }
    
    // MARK: Realm에서 태그 정보를 불러오는 메서드
    private func loadTagsFromDatabase() {
        let tags = database.read(Tag.self).sorted(byKeyPath: "position", ascending: true)
    }

    private func setupViews() {
        view.addSubview(horizontalStackView)
        view.addSubview(tagSettingCompletedButton)
        view.addSubview(tagsStackView)
        
        horizontalStackView.addArrangedSubview(label)
        horizontalStackView.addArrangedSubview(editTagButton)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.78)
        }
        
        tagsStackView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(view.bounds.height * 0.1)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        tagSettingCompletedButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().offset(-80)
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
        }
    }
    
// MARK: 1. 기본으로 + 버튼으로 태그 버튼 생성 2.태그모달뷰 불러올 때 렘에서 1~5번 정보 불러오기
//    private func addTagsToStackView() {
//        let buttonTitlesAndColors = [
//            ("명상", UIColor.red),
//            ("운동", UIColor.green),
//            ("공부", UIColor.purple),
//            ("+", UIColor.pomodoro.background),
//            ("+", UIColor.gray),
//            ("+", UIColor.gray),
//            ("+", UIColor.gray)
//        ]
//        let tagsPerRow = [2, 3, 2]
//        var currentIndex = 0
//
//        for count in tagsPerRow {
//            let rowStackView = UIStackView().then {
//                $0.axis = .horizontal
//                $0.spacing = 10
//                $0.alignment = .fill
//                $0.distribution = .fillEqually
//            }
//
//            for _ in 0 ..< count {
//                let (title, color) = buttonTitlesAndColors[currentIndex % buttonTitlesAndColors.count]
//                let button = createRoundButton(title: title, color: color, borderColor: color)
//                rowStackView.addArrangedSubview(button)
//                currentIndex += 1
//            }
//
//            tagsStackView.addArrangedSubview(rowStackView)
//        }
//    }
    
    // MARK: 커스텀 없이 만들고 렘이랑 연결
   //  태그 버튼을 추가하는 메서드
    private func addTagsToStackView() {
        guard let tags = tags else { return } // 여기서 안전하게 옵셔널을 언래핑합니다.
        
        let tagsPerRow = [2, 3, 2]
        var currentIndex = 0

        for count in tagsPerRow {
            let rowStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.spacing = 10
                $0.alignment = .fill
                $0.distribution = .fillEqually
            }
            for _ in 0 ..< count {
                if currentIndex < tags.count { // 인덱스 검사
                    let tag = tags[currentIndex]
                    let button = createRoundButton(tag: tag) // 태그 정보를 버튼 생성에 사용
                    rowStackView.addArrangedSubview(button)
                    currentIndex += 1
                }
            }

            tagsStackView.addArrangedSubview(rowStackView)
        }
    }

    // TODO: 테두리 컬러 확인
//    private func createRoundButton(title: String,
//                                   color: UIColor,
//                                   borderColor _: UIColor,
//                                   isEditButton: Bool = false) -> UIButton {
    private func createRoundButton(tag: Tag, isEditButton: Bool = false) -> UIButton {
    let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .pomodoroFont.heading4()
//            $0.backgroundColor = color
        $0.backgroundColor = .lightGray
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 40
            $0.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 80, height: 80))
            }
            $0.addTarget(self, action: #selector(configureTag), for: .touchUpInside)
        }
//    private func createRoundButton(tag: Tag) -> UIButton {
//        let button = UIButton().then {
//            $0.setTitle(tag.tagName, for: .normal)
//            $0.titleLabel?.font = .pomodoroFont.heading4()
//            $0.backgroundColor = tag.setupTagBackgroundColor() // 태그 색상 적용
//            $0.setTitleColor(tag.setupTagTypoColor(), for: .normal) // 태그 텍스트 색상 적용
//            $0.layer.cornerRadius = 20
//            $0.snp.makeConstraints { make in
//                make.size.equalTo(CGSize(width: 80, height: 80))
//            }
//        }
        
        // MARK: 'editTagButton' 추가 액션 설정
//        if isEditButton {
//            button.addTarget(self, action: #selector(editTagButtonTapped), for: .touchUpInside)
//        } else {
//            button.addTarget(self, action: #selector(configureTag), for: .touchUpInside)
//        }

        // MARK: `-` 버튼 추가

        let minusButton = UIButton().then {
            $0.setTitle("-", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.isHidden = true // 기본적으로 숨김
            $0.tag = 101 // 태그 설정
        }
        button.addSubview(minusButton)

        // MARK: minusButton 위치 설정
        minusButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.top).offset(5)
            make.right.equalTo(button.snp.right).offset(-5)
            make.width.height.equalTo(20) // 작은 버튼 크기
        }

        // MARK: minusButton에 삭제 액션 추가
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)


        return button
    }
    // TODO: 'editTagButton' 역할 생성 버튼
    private func setupEditButton() {
//        let editButton = createRoundButton(title: "Edit", color: .pomodoro.background, borderColor: .clear, isEditButton: true)
        // editButton을 뷰에 추가하는 로직 (예: 레이아웃 설정)
    }
    
    // MARK: 'editTagButton' 버튼이 눌렸을 때 실행 메소드
    @objc private func editTagButtonTapped() {
        tagSettingCompletedButton.isEnabled.toggle()
    }

    @objc private func minusButtonTapped() {
        // minusButton 클릭 시 실행될 로직
        tagSettingCompletedButton.isEnabled.toggle() // 태그 설정 완료 버튼 활성화
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc func configureTag() {
        let configureTagViewController = TagConfigurationViewController()
        let navigationController = UINavigationController(rootViewController: configureTagViewController)
        present(navigationController, animated: true, completion: nil)
        // TODO: minusbutton 클릭하하고 태그값 설정하려면 설정완료버튼 비활성화되는 오류 수정필요
        tagSettingCompletedButton.isEnabled.toggle()
    }
    
    @objc func didTapSettingCompleteButton() {
        tagSettingCompletedButton.isEnabled.toggle()
        if !tagSettingCompletedButton.isEnabled {
            dismiss(animated: true, completion: nil)
        }
    }

    // TODO: Tag 삭제 버튼 연결
    @objc func deletTag() {
        tagSettingCompletedButton.isEnabled.toggle()
        PomodoroPopupBuilder()
            .add(title: "태그 삭제")
            .add(body: "태그를 정말 삭제하시겠습니까? 한 번 삭제한 태그는 다시 되돌릴 수 없습니다.")
            .add(
                button: .confirm(
                    title: "확인",
                    action: { [weak self] in
//                        guard let button = sender.superview as? UIButton else { return }
//                        button.setTitle("+", for: .normal)
                    }
                )
            )
            .show(on: self)
    }

    // TODO: ellipsisbutton 클릭시 - 버튼 활성화 함수
    @objc private func createMinusButton() {
        tagSettingCompletedButton.isEnabled.toggle()
        for case let button as UIButton in tagsStackView.arrangedSubviews.flatMap(\.subviews) {
            if let minusButton = button.viewWithTag(101) as? UIButton {
                minusButton.isHidden.toggle()
                button.bringSubviewToFront(minusButton)
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
