//
//  StatusBarHelper.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let vc = self.viewControllers.last {
            return vc.preferredStatusBarStyle
        }
        
        return .default
    }
    
}
