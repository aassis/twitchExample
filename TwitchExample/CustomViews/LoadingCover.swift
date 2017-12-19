//
//  LoadingCover.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

@IBDesignable
public class LoadingCover: UIView {
    
    @IBInspectable public var itemsTintColor: UIColor = UIColor.gray {
        didSet {
            labelError.tintColor = itemsTintColor
        }
    }
    
    @IBInspectable public var indicatorTintColor: UIColor = UIColor.purple {
        didSet {
            activityIndicator.color = indicatorTintColor
        }
    }
    
    @IBInspectable public var textSize: CGFloat = 18.0 {
        didSet {
            labelError.font = UIFont.systemFont(ofSize: textSize)
        }
    }
    
    internal var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init()
    internal var labelError: UILabel = UILabel.init()
    internal var viewError: UIView = UIView.init()
    
    internal var tapGesture: UITapGestureRecognizer?
    internal var action: (() -> ())?
    
    internal var isLoading: Bool = false
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = indicatorTintColor
        self.addSubview(activityIndicator)
        self.bringSubview(toFront: activityIndicator)
        
        self.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        labelError.translatesAutoresizingMaskIntoConstraints = false
        labelError.text = Constants.kGeneralErrorMsg
        labelError.textAlignment = .center
        labelError.numberOfLines = 0
        labelError.lineBreakMode = .byWordWrapping
        labelError.font = UIFont.systemFont(ofSize: 18.0)
        labelError.textColor = itemsTintColor
        
        viewError.addSubview(labelError)
        viewError.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[label]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["label": labelError]))
        viewError.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics:  nil, views: ["label": labelError]))
        
        viewError.isUserInteractionEnabled = false
        viewError.translatesAutoresizingMaskIntoConstraints = false
        viewError.backgroundColor = UIColor.clear
        viewError.alpha = 0.0
        
        self.addSubview(viewError)
        
        self.addConstraint(NSLayoutConstraint.init(item: viewError, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: viewError, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[view]-40-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: ["view": viewError]))
        self.bringSubview(toFront: viewError)
    }
    
    public func setAction(_ action: @escaping (() ->())) {
        self.action = action
        
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(callAction))
            self.addGestureRecognizer(tapGesture!)
        }
    }
    
    @objc private func callAction() {
        if !isLoading {
            action?()
        }
    }
    
    public func startLoading() {
        activityIndicator.startAnimating()
        isLoading = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.viewError.alpha = 0.0
        }
    }
    
    public func displayErrorWith(_ text: String) {
        labelError.text = String(format: "Uh-oh, we found a problem:\n\n%@\n\nTap to try again.", text)
        activityIndicator.stopAnimating()
        isLoading = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.viewError.alpha = 1.0
        }
    }
    
    public func show(_ show: Bool) {
        if show {
            isLoading = true
            viewError.alpha = 0.0
            activityIndicator.startAnimating()
            self.isHidden = false
            self.alpha = 1.0
        } else {
            isLoading = false
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.alpha = 0.0
            }) { [weak self] (c:Bool) in
                if c {
                    self?.isHidden = true
                }
            }
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
