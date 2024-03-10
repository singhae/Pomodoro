//
//  UILabelExtension.swift
//  Pomodoro
//
//  Created by 김하람 on 3/10/24.
//

import UIKit

extension UILabel {
    func setAttributedTextColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}
