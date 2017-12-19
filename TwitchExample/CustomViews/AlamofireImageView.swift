//
//  AlamofireImageView.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class AlamofireImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = -1.0
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            if let c = borderColor {
                self.layer.borderColor = c.cgColor
            } else {
                self.layer.borderColor = nil
                self.layer.borderWidth = 0.0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius >= 0 {
            self.layer.cornerRadius = cornerRadius
        } else {
            self.layer.cornerRadius = self.bounds.size.height/2
        }
    }
    
    func loadImageFor(url urlString: String) {
        if let url = URL(string: urlString) {
            self.af_setImage(withURL: url, placeholderImage: nil, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: false)
            self.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.custom(duration: 0.2, animationOptions: UIViewAnimationOptions.transitionCrossDissolve, animations: { (imgView, img) in
                imgView.alpha = 1.0
            }, completion: { (c:Bool) in
                if c {
                    self.layoutIfNeeded()
                }
            }), runImageTransitionIfCached: false, completion: nil)
        }
    }
}
