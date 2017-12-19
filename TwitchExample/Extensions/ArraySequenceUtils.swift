//
//  ArraySequenceUtils.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation

extension Array {
    
    func itemFor(index: IndexPath) -> Element? {
        if index.row < self.count && index.row >= 0 {
            return self[index.row]
        }
        return nil
    }
    
    func itemFor(index: Int) -> Element? {
        if index < self.count && index >= 0 {
            return self[index]
        }
        return nil
    }
    
}
