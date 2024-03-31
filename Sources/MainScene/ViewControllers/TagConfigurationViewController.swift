//
//  TagConfigurationViewController.swift
//  Pomodoro
//
//  Created by SonSinghae on 2024/02/15.
//

import PomodoroDesignSystem
import SnapKit
import Then
import UIKit

final class TagConfigurationViewController: UIViewController, UITextFieldDelegate {
    private func configureNavigationBar() {
        navigationItem.title = "태그 설정"
        let dismissButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(dismissModal)
        )
        navigationItem.leftBarButtonItem = dismissButtonItem
    }
    

    private lazy var textField: UITextField = {
            let textField = UITextField()
            textField.borderStyle = .none
            textField.placeholder = "ex. 공부"
        textField.font = .pomodoroFont.heading6()
            textField.textAlignment = .left
            let bottomLine = UIView()
            bottomLine.backgroundColor = .black
            textField.addSubview(bottomLine)
            bottomLine.snp.makeConstraints { make in
                make.bottom.equalTo(textField.snp.bottom).offset(10)
                make.left.right.equalTo(textField)
                make.height.equalTo(2)
            }
            return textField
        }()
    // TODO: 태그 생성 폰트 적용
    private lazy var saveTagButton = PomodoroConfirmButton(title: "태그 생성", didTapHandler: saveTagButtonTapped)
    
    private let colorPaletteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    weak var delegate: TagCreationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        textField.delegate = self
        setupViews()
        setupConstraints()
        setupColorPalette()
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTagButtonTapped() {
        guard let tagText = textField.text, !tagText.isEmpty else {
            print("태그를 입력하세요.")
            //            let alert = UIAlertController(title: "경고", message: "태그를 입력하세요.", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "확인", style: .default))
            //            present(alert, animated: true)
            PomodoroPopupBuilder()
                .add(body: "태그를 입력해주십시오.")
                .add(
                    button: .confirm(
                        title: "확인",
                        action: { /* 확인 동작 */ }
                    )
                )
                .show(on: self)
            return
        }
        delegate?.createTag(tag: tagText)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(saveTagButton)
        view.addSubview(colorPaletteStackView)
    }
    
    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            //make.top.equalTo(view.snp.bottom).offset(20)
           // make.top.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            make.left.right.equalToSuperview().inset(40)
            //make.height.equalTo(44)
        }
        colorPaletteStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        saveTagButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(45)
            make.trailing.equalToSuperview().offset(-45)
            make.bottom.equalToSuperview().offset(-(view.bounds.height * 0.2))
        }
    }
    
    private func setupColorPalette() {
        let colors: [UIColor] = [
            .red,
            .orange,
            .yellow,
            .green,
            .blue,
            .purple,
            .brown,
            .magenta
        ]
        
        // colorPaletteStackView 설정
        colorPaletteStackView.axis = .vertical
        colorPaletteStackView.distribution = .fillEqually
        colorPaletteStackView.spacing = 10
        
        // 2행 4열
        let rows = [UIStackView(), UIStackView()]
        rows.forEach { row in
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 10
            colorPaletteStackView.addArrangedSubview(row)
        }
        
        // 각 행에 색상 버튼 추가
        for (index, color) in colors.enumerated() {
            let colorButton = UIButton().then{
                $0.backgroundColor = color
                $0.layer.cornerRadius = 25
                $0.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 50, height: 50))
                }
                    $0.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
                }
                // 적절한 행에 버튼 추가
                if index < 4 {
                    rows[0].addArrangedSubview(colorButton)
                } else {
                    rows[1].addArrangedSubview(colorButton)
                }
            }
        }
        
    // TODO: color 버튼 클릭시 정보 전달 로직, 화면상 나타나는 표시(컬러 변경이 더 쉬울 것 같음)
        @objc private func colorButtonTapped(_ sender: UIButton) {
            guard let selectedColor = sender.backgroundColor else { return }
        }
        
    }
