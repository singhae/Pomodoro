//
//  TagModalViewController.swift
//  Pomodoro
//
//  Created by SonSinghae on 2023/11/17.
//  Copyright © 2023 io.hgu. All rights reserved.
//
import SnapKit
import Then
import UIKit

class TagModalViewController: UIViewController {
    
    private let label = UILabel().then {
        $0.text = "태그"
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.numberOfLines = 0
        //$0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let tableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.contentInset = .zero
        $0.estimatedRowHeight = 34
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") // cell 이름 변경 -> TagitemCell로 변경
        //$0.translatesAutoresizingMaskIntoConstraints = false

        //        redBox.snp.makeConstraints { (make) in
        //                    make.width.height.equalTo(100)
        //        // 너비, 높이 모두 100으로
        //        //            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        //        //            make.centerX.equalToSuperview()
        //        make.center.equalToSuperview()
    }
    
//    var scrollView: UIScrollView {
//        tableView
//    }
    
    //이거 말고 다른 방법 사용
    private let items = (0...10).map(String.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        
        view.addSubview(label)
        view.addSubview(tableView)
        
        // snapkit 사용으로 수정
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        tableView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.bottom.equalToSuperview()

        }
//        NSLayoutConstraint.activate([
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.topAnchor.constraint(equalTo: label.bottomAnchor),
//        ])
//        redBox.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//        redBox.widthAnchor.constraint(equalToConstant: 100),
//        redBox.heightAnchor.constraint(equalToConstant: 100),
//        redBox.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//        redBox.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
//        ])
//        redBox.snp.makeConstraints { (make) in
//                    make.width.height.equalTo(100)
//        // 너비, 높이 모두 100으로
//        //            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
//        //            make.centerX.equalToSuperview()
//        make.center.equalToSuperview()
//        // 상위 뷰와 center x,y 같게
//        }()
        
        
    }
}

extension TagModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = items[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
