//
//  HomeViewController.swift
//  Pomodoro
//
//  Created by 전여훈 on 2023/11/02.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstVC = dataViewControllers.first(where: { $0 is SecondViewController }) {
                   pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
       }
        setupDelegate()
        configure()
    }
    private lazy var dataViewControllers: [UIViewController] = {
        return [FirstViewController(), SecondViewController(), ThirdViewController()]
    }()

    lazy var pageViewController: UIPageViewController = {
       let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
       return vc
    }()
    
    private func configure() {
       view.addSubview(navigationView)
       addChild(pageViewController)
       view.addSubview(pageViewController.view)

       navigationView.snp.makeConstraints { make in
           make.width.top.equalToSuperview()
           make.height.equalTo(72)
       }

       pageViewController.view.snp.makeConstraints { make in
           make.top.equalTo(navigationView.snp.bottom)
           make.leading.trailing.bottom.equalToSuperview()
       }
       pageViewController.didMove(toParent: self)
    }
    private func setupDelegate() {
       pageViewController.dataSource = self
       pageViewController.delegate = self
    }
}

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

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
