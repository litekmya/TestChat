//
//  LabelPadding.swift
//  TestChat
//
//  Created by Владимир Ли on 09.07.2022.
//

import UIKit

class LabelPadding: UILabel {
    
    private let padding = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
    
    override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        let width = contentSize.width + padding.left + padding.right
        let height = contentSize.height + padding.top + padding.bottom
        
        return CGSize(width: width, height: height)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 8
        numberOfLines = 0
        backgroundColor = UIColor.systemGreen
    }
}
