//
//  LongBreakModalViewController.swift
//  Pomodoro
//
//  Created by 김현기 on 1/11/24.
//  Copyright © 2024 io.hgu. All rights reserved.
//

import Foundation
import UIKit

final class LongBreakModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let label = UILabel().then {
        $0.text = "긴 휴식"
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

    func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        40
    }

    func pickerView(
        _: UIPickerView,
        titleForRow row: Int,
        forComponent _: Int
    ) -> String? {
        String(row + 20) + "분"
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        textField.text = (String(row + 20) + "분")
    }
}
