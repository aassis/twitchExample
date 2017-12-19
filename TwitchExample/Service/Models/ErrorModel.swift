//
//  ErrorModel.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import Gloss

class ErrorModel: JSONDecodable {
    
    let message: String!
    let status: Int!
    let errorString: String!
    
    required init?(json: JSON) {
        guard let message: String = "message" <~~ json,
            let status: Int = "status" <~~ json,
            let errorString: String = "error" <~~ json else {
                return nil
        }
        
        self.message = message
        self.status = status
        self.errorString = errorString
    }
    
}
