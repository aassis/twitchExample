//
//  SearchBarTextColor.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

extension UISearchBar {
    public func setTextColor(color: UIColor) {
        if let searchField = self.value(forKey: "searchField") as? UITextField {
            searchField.textColor = color
        }
        return
    }
}
