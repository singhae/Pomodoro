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
    
    private let titleLabel = UILabel().then {
        $0.text = "태그명"
        $0.font = .systemFont(ofSize: 16)
        //$0.font = .pomodoroFont
        $0.textColor = .pomodoro.blackHigh
    }
    
    private let textField = UITextField().then {
        $0.borderStyle = .none
        $0.placeholder = "ex.공부"
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.backgroundColor = .clear
        $0.textColor = .white
    }
    
    private lazy var saveTagButton = PomodoroConfirmButton(title: "test", didTapHandler: saveTagButtonTapped)
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
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(saveTagButton)
        view.addSubview(colorPaletteStackView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        colorPaletteStackView.snp.makeConstraints { make in
            //            make.top.equalTo(textField.snp.bottom).offset(20)
            //            make.left.right.equalToSuperview().inset(20)
            //            make.height.equalTo(120)
            make.centerY.equalToSuperview().offset(-20) // 필요한 경우 여기서 offset 조정
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(120) // 스택 뷰의 높이, 필요에 따라 조정
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
        
        @objc private func colorButtonTapped(_ sender: UIButton) {
            guard let selectedColor = sender.backgroundColor else { return }
        }
        
    }
