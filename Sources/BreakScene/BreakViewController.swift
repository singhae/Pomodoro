//
//  BreakViewController.swift
//  Pomodoro
//
//  Created by 김하람 on 2/19/24.
//

import UIKit

final class BreakViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }

    private func setUI() {
        let breakImage = UIImageView().then {
            view.addSubview($0)
            $0.image = UIImage(systemName: "hand.thumbsup")?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.isHidden = false
            $0.alpha = 1.0
            $0.tintColor = .blue
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(289)
                make.width.equalTo(289)
            }
        }

        let breakButton = UIButton().then {
            view.addSubview($0)
            $0.setTitle("휴식하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
            $0.addTarget(self, action: #selector(breakButtonTapped), for: .touchUpInside)
            $0.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(breakImage.snp.bottom).offset(30)
            }
        }
    }

    @objc func breakButtonTapped() {
        let breakTimeVC = BreakTimerViewController()
        navigationController?.pushViewController(breakTimeVC, animated: true)
    }
}
