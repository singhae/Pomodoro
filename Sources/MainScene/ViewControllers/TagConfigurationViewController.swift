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
        // FIXME: 배경색 기본 배경 색이랑 동일하게
        // FIXME: 텍스트 글자 색 : 흰색
    }

    private let saveTagButton = UIButton().then {
        $0.backgroundColor = .pomodoro.background
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    weak var delegate: TagCreationDelegate?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background
        textField.delegate = self
        setupViews()
        setupConstraints()
        saveTagButton.addTarget(self, action: #selector(saveTagButtonTapped), for: .touchUpInside)
        configureColorPickerTextField()
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // FIXME: 디버깅
        print("textField의 현재 값: \(textField.text ?? "nil")")
        self.textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        print("text 필드 비활성화")
        return true
    }

    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(saveTagButton)
    }

    private func configureColorPickerTextField() {
        let colorPaletteButton = UIButton(type: .custom)
        colorPaletteButton.backgroundColor = .systemGray
        colorPaletteButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        colorPaletteButton.layer.cornerRadius = 7.5
        colorPaletteButton.layer.masksToBounds = true
        colorPaletteButton.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)

        textField.rightView = colorPaletteButton
        textField.rightViewMode = .always
    }

    @objc private func colorPaletteButtonTapped() {
        let colorPaletteVC = ColorPaletteViewController()
        colorPaletteVC.modalPresentationStyle = .popover // FIXME: 하프 모달로 구현
        present(colorPaletteVC, animated: true, completion: nil)
    }

    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(44)
        }

        saveTagButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.left.equalTo(textField.snp.right).offset(10)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
