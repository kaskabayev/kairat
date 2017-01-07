//
//  CustomLabel.swift
//  kairat
//
//  Created by Beka on 12/30/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

     var topInset: CGFloat = 0
     var bottomInset: CGFloat = 0
     var leftInset: CGFloat = 0
     var rightInset: CGFloat = 0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
