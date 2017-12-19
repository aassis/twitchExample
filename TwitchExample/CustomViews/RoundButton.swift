//
//  RoundButton.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundButton: UIButton {
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }

    private var originalBgColor: UIColor!
    @IBInspectable var hightlightedBgColor: UIColor?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.originalBgColor = self.backgroundColor
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if !isHighlighted {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = self.isSelected ? self.hightlightedBgColor : self.originalBgColor
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = self.isSelected ? self.originalBgColor : self.hightlightedBgColor
                })
            }
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            if !isSelected {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = self.originalBgColor
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = self.hightlightedBgColor
                })
            }
        }
    }

}
