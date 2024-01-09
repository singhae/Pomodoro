//
//  TagCollectionViewCell.swift
//  Pomodoro
//
//  Created by SonSinghae on 2023/12/31.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import SnapKit
import Then

class TagCollectionViewCell: UICollectionViewCell {
    
    let tagLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    var dataLabel = UILabel()
    
    static var id: String {
        if let className = NSStringFromClass(Self.self).components(separatedBy: ".").last {
            return className
        } else {
            return "DefaultClassName"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    
    private func configure() {
        dataLabel = UILabel()
        dataLabel.font = UIFont.systemFont(ofSize: 15)
        dataLabel.textColor = .label
        dataLabel.textAlignment = .center
        dataLabel.backgroundColor = .systemIndigo
        
        contentView.addSubview(dataLabel)
        
        dataLabel.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
