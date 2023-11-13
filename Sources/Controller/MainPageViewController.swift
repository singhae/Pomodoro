//
//  MainPageViewController.swift
//  Pomodoro
//
//  Created by 전여훈 on 2023/11/02.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit

final class MainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstVC = dataViewControllers.first(where: { $0 is MainViewController }) {
                   pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
       }
        setupDelegate()
        setupPageViewController()
    }
    private lazy var dataViewControllers: [UIViewController] = {
        return [SettingViewController(), MainViewController(), DashBoardViewController()]
    }()

    private lazy var pageViewController: UIPageViewController = {
       let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       return vc
    }()
    
    private func setupPageViewController() {
       addChild(pageViewController)
       view.addSubview(pageViewController.view)
      
       pageViewController.view.snp.makeConstraints { make in
           make.edges.equalToSuperview()
       }
       pageViewController.didMove(toParent: self)
    }
    private func setupDelegate() {
       pageViewController.dataSource = self
       pageViewController.delegate = self
    }
}

extension MainPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
}
