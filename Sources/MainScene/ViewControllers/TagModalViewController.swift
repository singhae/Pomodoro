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

    private var tagCollectionView: TagCollectionView!
        private let dataSource = TagCollectionViewData.data

        override func viewDidLoad() {
            super.viewDidLoad()

            configure()

            registerCollectionView()

            setupCollectionViewDelegate()

        }

       private func configure() {

           let collectionViewLayer = UICollectionViewFlowLayout()
           collectionViewLayer.sectionInset = UIEdgeInsets(top: 5.0, left: 7.0, bottom: 5.0, right: 7.0)
           collectionViewLayer.minimumLineSpacing = 5
           collectionViewLayer.minimumInteritemSpacing = 1

           tagCollectionView = TagCollectionView(frame: .zero, collectionViewLayout: collectionViewLayer)
           tagCollectionView.backgroundColor = .secondarySystemBackground
           view.addSubview(tagCollectionView)

           tagCollectionView.snp.makeConstraints { make in
               make.top.equalTo(120)
               make.left.right.bottom.equalToSuperview().inset(40)
           }
       }

       private func registerCollectionView() {
           tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.id)
       }

       private func setupCollectionViewDelegate() {
           tagCollectionView.dataSource = self
           tagCollectionView.delegate = self
       }

}

extension TagModalViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.id, for: indexPath) as! TagCollectionViewCell
        cell.dataLabel.text = dataSource[indexPath.item]
        return cell
    }
}
