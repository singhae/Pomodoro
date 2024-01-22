//
//  ShortBreakModalViewController.swift
//  Pomodoro
//
//  Created by 김현기 on 1/11/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import Foundation
import UIKit

final class ShortBreakModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let label = UILabel().then {
        $0.text = "짧은 휴식"
    }

    private var textField = UITextField().then {
        $0.text = ""
    }

    private var minutePicker: UIPickerView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(label)
        view.addSubview(minutePicker)
        view.addSubview(textField)

        minutePicker.sizeToFit()
        minutePicker.delegate = self
        minutePicker.dataSource = self

        setupConstraints()
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }

        minutePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(10)
        }

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(minutePicker.snp.bottom).offset(10)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 20
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1) + "분"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = (String(row + 1) + "분")
    }

}
