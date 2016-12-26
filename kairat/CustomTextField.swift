//
//  CustomTextField.swift
//  kairat
//
//  Created by Beka on 12/6/16.
//  Copyright © 2016 Beka. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 3.5
        
        tintColor=UIColor.white
        tintColor.setStroke()
        
        path.stroke()
    }
    
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
