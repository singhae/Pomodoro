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
    // MARK: 태그명 레이블

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태그명"
        label.font = .pomodoroFont.heading5()
        label.textAlignment = .left
        return label
    }()
    
    private let paletteTitleLabel = UILabel().then { label in
        label.text = "태그 색상"
        label.font = .pomodoroFont.heading5()
        label.textAlignment = .left
    }

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.placeholder = "ex. 공부"
        textField.font = .pomodoroFont.heading6()
        textField.delegate = self
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
    private lazy var createTagConfirmButton = PomodoroConfirmButton(title: "태그 생성",
                                                                    didTapHandler: saveTagButtonTapped)

    private let colorPaletteStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    private let dimmedView = UIView().then {
        $0.backgroundColor = .pomodoro.blackHigh.withAlphaComponent(0.2)
    }
    
    private let titleView = UILabel().then {
        $0.text = "태그 설정"
        $0.font = .pomodoroFont.heading4()
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "closeButton"), for: .normal)
    }

    weak var delegate: TagCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        navigationController?.isNavigationBarHidden = false
        setupViews()
        setupConstraints()
        setupColorPalette()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveTagButtonTapped() {
        guard let tagText = textField.text, !tagText.isEmpty else {
            print("태그를 입력하세요.")
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
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        let contentView = UIView().then {
            $0.backgroundColor = .pomodoro.background
            $0.layer.cornerRadius = 20
            $0.addSubview(titleView)
            $0.addSubview(closeButton)
            $0.addSubview(titleLabel)
            $0.addSubview(textField)
            $0.addSubview(paletteTitleLabel)
            $0.addSubview(createTagConfirmButton)
            $0.addSubview(colorPaletteStackView)
        }
        dimmedView.addSubview(contentView)
        view.addSubview(dimmedView)
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(view.frame.height * 0.8)
        }
    }

    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(20)
        }
        
        titleView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton.snp.centerY)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(59)
            make.left.equalToSuperview().inset(40)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(40)
//            make.height.equalTo(44)
        }
        
        paletteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(52)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        colorPaletteStackView.snp.makeConstraints { make in
            make.top.equalTo(paletteTitleLabel.snp.bottom).offset(34)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(150)
        }

        createTagConfirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(110)
            make.top.equalTo(colorPaletteStackView.snp.bottom).offset(66)
            make.height.equalTo(60)
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
        colorPaletteStackView.spacing = 20
        // 2행 4열
        let rows = [UIStackView(), UIStackView()]
        for row in rows {
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = 15
            colorPaletteStackView.addArrangedSubview(row)
        }

        // 각 행에 색상 버튼 추가
        for (index, color) in colors.enumerated() {
            let colorButton = UIButton().then {
                $0.backgroundColor = color
                $0.layer.cornerRadius = 33
                $0.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 55, height: 55))
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

extension TagConfigurationViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
