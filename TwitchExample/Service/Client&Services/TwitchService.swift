//
//  TwitchService.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import Moya

enum TwitchService {
    case getTopGames(offset: Int, limit: Int)
}

extension TwitchService: TargetType {
    var baseURL: URL {
        return URL(string: Config.kBasePath)!
    }
    
    var path: String {
        switch self {
        case .getTopGames:
            return "/games/top"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTopGames:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getTopGames(let offset, let limit):
            return .requestParameters(parameters: ["offset": offset, "limit": limit], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }
}
