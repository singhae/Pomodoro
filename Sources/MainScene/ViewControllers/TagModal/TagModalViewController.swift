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
    }
    
    private let tableView = UITableView().then {
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.contentInset = .zero
        $0.estimatedRowHeight = 34
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "TagItemCell")
    }
    
    var scrollView: UIScrollView {
        tableView
    }
    
    //이거 말고 다른 방법 사용
    private let items = (0..<11).map(String.init)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        
        view.addSubview(label)
        view.addSubview(tableView)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension TagModalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagItemCell")
        cell?.textLabel?.text = items[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
