//
//  CommentTextFiled.swift
//  kairat
//
//  Created by beka on 1/17/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import UIKit

class CommentTextFiled: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
