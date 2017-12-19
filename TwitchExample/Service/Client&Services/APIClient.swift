//
//  APIClient.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Moya
import Alamofire

class APIClient {
    
    var twitchProvider: MoyaProvider<TwitchService>!
    
    init(_ manager:SessionManager? = nil) {
        var m = manager
        
        if(m == nil) {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Client-ID": "bd421xhdlu9zlqnw7fskdq9a0ztn82"]
            m = Alamofire.SessionManager(configuration: configuration)
        }
        
        twitchProvider = MoyaProvider<TwitchService>(manager: m!)
    }
    
}
