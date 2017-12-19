//
//  RoundCornersView.swift
//  Practice
//
//  Created by Andre Assis on 17/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

class RoundCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    @IBInspectable var topLeftCorner: Bool = true
    @IBInspectable var topRightCorner: Bool = true
    @IBInspectable var botLeftCorner: Bool = true
    @IBInspectable var botRightCorner: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var corners = UIRectCorner()
        
        if topLeftCorner { corners.update(with: .topLeft) }
        if topRightCorner { corners.update(with: .topRight) }
        if botLeftCorner { corners.update(with: .bottomLeft) }
        if botRightCorner { corners.update(with: .bottomRight) }
        
        roundCorners(corners, radius: cornerRadius)
    }
    
    private func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
