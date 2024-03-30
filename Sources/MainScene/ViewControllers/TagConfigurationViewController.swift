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
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "태그를 입력하세요"
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.backgroundColor = .clear
        $0.textColor = .white
    }
    
    private lazy var saveTagButton = PomodoroConfirmButton(title: "test", didTapHandler: saveTagButtonTapped)

    private let colorPaletteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }

    weak var delegate: TagCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        textField.delegate = self
        setupViews()
        setupConstraints()
        setupColorPalette()
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(44)
        }

        colorPaletteStackView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
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
            let colorButton = UIButton()
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = 22 // 가정: 버튼 크기를 44x44로 설정
            colorButton.snp.makeConstraints { make in
                make.width.height.equalTo(44)
            }
            colorButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            
            // 적절한 행에 버튼 추가
            if index < 4 {
                rows[0].addArrangedSubview(colorButton)
            } else {
                rows[1].addArrangedSubview(colorButton)
            }
        }
    }

    @objc private func colorButtonTapped(_ sender: UIButton) {
        guard let selectedColor = sender.backgroundColor else { return }
    }

}
