//
//  SettingViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import SnapKit
import Then
import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let options =
        ["짧은 휴식 시간 설정하기", "긴 휴식 시간 설정하기", "뽀모도로 완료 진동", "데이터 초기화하기", "타이머 특수효과", "서비스 평가하러 가기", "오픈 소스 라이센스"]

    let titleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }

    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        $0.isScrollEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addSubViews()
        setupConstraints()

    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "OptionCell")
        var config = cell.defaultContentConfiguration()
        let option = options[indexPath.row]

        config.text = option
        cell.textLabel?.text = option

        if option == "짧은 휴식 시간 설정하기" {
            cell.accessoryType = .disclosureIndicator
            config.secondaryText = "5min"
            cell.detailTextLabel?.text = config.secondaryText
        }
        if option == "긴 휴식 시간 설정하기" {
            cell.accessoryType = .disclosureIndicator
            config.secondaryText = "30min"
            cell.detailTextLabel?.text = config.secondaryText
        }

        if option == "뽀모도로 완료 진동" {
            _ = UISwitch(frame: .zero).then {
                $0.setOn(false, animated: true) // switch 초기설정 지정
                $0.tag = indexPath.row // tag 지정
//                $0.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>) // addTarget 지정
                cell.accessoryView = $0
            }
        }
        if option == "타이머 특수효과" {
            _ = UISwitch(frame: .zero).then {
                $0.setOn(false, animated: true) // switch 초기설정 지정
                $0.tag = indexPath.row // tag 지정
//                $0.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>) // addTarget 지정
                cell.accessoryView = $0
            }
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        if selectedOption == "짧은 휴식 시간 설정하기" {
            presentModal(modalViewController: ShortBreakModalViewController())
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else if selectedOption == "긴 휴식 시간 설정하기" {
            presentModal(modalViewController: LongBreakModalViewController())
            tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            let detailViewController = DetailViewController(option: selectedOption)
            navigationController?.pushViewController(detailViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }

    }

    private func presentModal(modalViewController: UIViewController) {
        let breakModal = modalViewController
        let nav = UINavigationController(rootViewController: breakModal)

        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        present(nav, animated: true, completion: nil)
    }
}

// MARK: UI

extension SettingViewController {
    private func addSubViews() {
        view.addSubview(titleLabel)
        navigationItem.title = "Options"
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

class DetailViewController: UIViewController {

    let optionLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    init(option: String) {
        super.init(nibName: nil, bundle: nil)
        optionLabel.text = option
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(optionLabel)

        optionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
