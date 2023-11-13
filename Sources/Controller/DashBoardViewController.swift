//
//  DashBoardViewController.swift
//  Pomodoro
//
//  Created by 진세진 on 2023/11/06.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit

final class DashBoardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewControllers()
        setupSegmentedControl()
        setupContainerView()
        segmentChanged()
    }
    private let containerView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(tabBarControl.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private let tabBarControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["일", "주", "월", "년"])
        segmentedControl.backgroundColor = .white
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var dayVC: UIViewController!
    private var weekVC: UIViewController!
    private var monthVC: UIViewController!
    private var yearVC: UIViewController!
    
    private func setupSegmentedControl() {
        view.addSubview(tabBarControl)
        tabBarControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
        tabBarControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func setupViewControllers() {
        dayVC = DayViewController()
        weekVC = WeekViewController()
        monthVC = MonthViewController()
        yearVC = YearViewController()
        
        addChild(dayVC)
        containerView.addSubview(dayVC.view)
        dayVC.view.frame = containerView.bounds
        dayVC.didMove(toParent: self)
        
        addChild(weekVC)
        containerView.addSubview(weekVC.view)
        weekVC.view.frame = containerView.bounds
        weekVC.didMove(toParent: self)
        
        addChild(monthVC)
        containerView.addSubview(monthVC.view)
        monthVC.view.frame = containerView.bounds
        monthVC.didMove(toParent: self)
        
        addChild(yearVC)
        containerView.addSubview(yearVC.view)
        yearVC.view.frame = containerView.bounds
        yearVC.didMove(toParent: self)
    }
    
    @objc private func segmentChanged() {
        switch tabBarControl.selectedSegmentIndex {
        case 0:
            dayVC.view.isHidden = false
            weekVC.view.isHidden = true
            monthVC.view.isHidden = true
            yearVC.view.isHidden = true
        case 1:
            dayVC.view.isHidden = true
            weekVC.view.isHidden = false
            monthVC.view.isHidden = true
            yearVC.view.isHidden = true
        case 2:
            dayVC.view.isHidden = true
            weekVC.view.isHidden = true
            monthVC.view.isHidden = false
            yearVC.view.isHidden = true
        case 3:
            dayVC.view.isHidden = true
            weekVC.view.isHidden = true
            monthVC.view.isHidden = true
            yearVC.view.isHidden = false
        default:
            break
        }
    }
}
