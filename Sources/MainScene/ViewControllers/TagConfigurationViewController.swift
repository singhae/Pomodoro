//
//  TagConfigurationViewController.swift
//  Pomodoro
//
//  Created by SonSinghae on 2024/02/15.
//

import SnapKit
import Then
import UIKit

class TagConfigurationViewController: UIViewController, UITextFieldDelegate {
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.placeholder = "태그를 입력하세요"
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        // 배경색 기본 배경 색이랑 동일하게
        // 텍스트 글자 색 : 흰색
    }

    // 저장 버튼 생성
    private let saveButton = UIButton().then {
        $0.backgroundColor = UIColor.systemGray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    weak var delegate: TagCreationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .white
        textField.delegate = self
        setupViews()
        setupConstraints()
        // 버튼 액션 추가
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc func saveButtonTapped() {
        print("저장 버튼이 탭되었습니다.")
        // 저장 로직 구현
        guard let tagText = textField.text, !tagText.isEmpty else {
            print("태그를 입력하세요.")
            // 사용자에게 텍스트 필드가 비어 있음을 알립니다.
            let alert = UIAlertController(title: "경고", message: "태그를 입력하세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        delegate?.didCreateTag(tag: tagText)
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 디버깅
        print("textField의 현재 값: \(textField.text ?? "nil")")

        self.textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        print("text 필드 비활성화")
        return true
    }

    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(saveButton) // 뷰에 저장 버튼 추가
    }

    private func setupConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(70) // 텍스트 필드의 오른쪽 여백 조정
            make.height.equalTo(44)
            // 하프 모달로 구현
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.left.equalTo(textField.snp.right).offset(10) // 텍스트 필드 바로 오른쪽에 위치
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
}
