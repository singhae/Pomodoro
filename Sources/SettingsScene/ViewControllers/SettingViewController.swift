//
//  SettingViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import PomodoroDesignSystem
import SnapKit
import Then
import UIKit

final class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let database = DatabaseManager.shared

    private enum SettingOption: CaseIterable {
        case shortBreak, longBreak, completionVibrate, dataReset, timerEffect, serviceReview, OSLicense

        var title: String {
            switch self {
            case .shortBreak:
                return "짧은 휴식 설정하기"
            case .longBreak:
                return "긴 휴식 설정하기"
            case .completionVibrate:
                return "뽀모도로 완료 진동"
            case .dataReset:
                return "데이터 초기화하기"
            case .timerEffect:
                return "타이머 특수효과"
            case .serviceReview:
                return "서비스 평가하러 가기"
            case .OSLicense:
                return "오픈 소스 라이센스"
            }
        }
    }

    private let titleLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    }

    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .pomodoro.background
        $0.contentInset = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 17)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        $0.isScrollEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pomodoro.background

        print(database.getLocationOfDefaultRealm())
        let options = database.read(Option.self)
        if options.isEmpty {
            database.write(
                Option(
                    shortBreakTime: 5,
                    longBreakTime: 20,
                    isVibrate: false,
                    isTimerEffect: true
                )
            )
            print("Option Realm Initialized..")
        }

        print("Realm Option: \(database.read(Option.self))")

        addSubViews()
        setupConstraints()
    }

    // MARK: - UITableViewDataSource

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        SettingOption.allCases.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .value1,
            reuseIdentifier: "OptionCell"
        )
        cell.backgroundColor = .pomodoro.background
        var config = cell.defaultContentConfiguration()
        let option = SettingOption.allCases[indexPath.row]

        config.text = option.title
        cell.textLabel?.text = option.title
//        cell.textLabel?.font =

        switch SettingOption.allCases[indexPath.row] {
        case .shortBreak:
            cell.accessoryType = .disclosureIndicator
            config.secondaryText = "5min"
            cell.detailTextLabel?.text = config.secondaryText
        case .longBreak:
            cell.accessoryType = .disclosureIndicator
            config.secondaryText = "20min"
            cell.detailTextLabel?.text = config.secondaryText
        case .completionVibrate:
            _ = UISwitch(frame: .zero).then {
                $0.setOn(false, animated: true) // switch 초기설정 지정
                $0.tag = indexPath.row // tag 지정
                cell.accessoryView = $0
            }
            cell.selectionStyle = .none
        case .timerEffect:
            _ = UISwitch(frame: .zero).then {
                $0.setOn(false, animated: true) // switch 초기설정 지정
                cell.accessoryView = $0
            }
            cell.selectionStyle = .none
        default:
            return cell
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = SettingOption.allCases[indexPath.row]

        switch selectedOption {
        case .shortBreak:
            presentModal(modalViewController: ShortBreakModalViewController())
            tableView.deselectRow(at: indexPath, animated: true)
        case .longBreak:
            presentModal(modalViewController: LongBreakModalViewController())
            tableView.deselectRow(at: indexPath, animated: true)
        case .dataReset:
            presentModal(modalViewController: DataResetModalViewController())
            tableView.deselectRow(at: indexPath, animated: true)
        case .completionVibrate:
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        case .timerEffect:
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        default:
            let detailViewController = DetailViewController(option: selectedOption.title)
            navigationController?.pushViewController(detailViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    private func presentModal(modalViewController: UIViewController) {
        let breakModal = modalViewController
        let nav = UINavigationController(rootViewController: breakModal)

        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
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
            make.leading.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().inset(9)
            make.bottom.equalToSuperview()
        }
    }
}

final class DetailViewController: UIViewController {
    private let optionLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    init(option: String) {
        super.init(nibName: nil, bundle: nil)
        optionLabel.text = option
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
