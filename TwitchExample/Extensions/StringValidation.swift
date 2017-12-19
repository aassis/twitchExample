//
//  StringValidation.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation

extension String {
    
    public func diacriticString() -> String {
        return self.folding(options: String.CompareOptions.diacriticInsensitive, locale: .current)
    }
    
}
