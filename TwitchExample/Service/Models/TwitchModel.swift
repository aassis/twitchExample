//
//  TwitchModel.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Foundation
import Gloss

class TwitchTopGamesResponse: JSONDecodable {
    
    let totalGames: Int!
    let topGames: [TwitchTopGameModel]!
    
    required init?(json: JSON) {
        guard let totalGames: Int = "_total" <~~ json,
            let topGames: [TwitchTopGameModel] = "top" <~~ json else {
            return nil
        }
        
        self.totalGames = totalGames
        self.topGames = topGames
    }
    
}

class TwitchTopGameModel: JSONDecodable {
    
    let channels: Int!
    let viewers: Int!
    let game: GameModel!
    
    required init?(json: JSON) {
        guard let channels: Int = "channels" <~~ json,
            let viewers: Int = "viewers" <~~ json,
            let game: GameModel = "game" <~~ json else {
                return nil
        }
        
        self.channels = channels
        self.viewers = viewers
        self.game = game
    }
    
}

class GameModel: JSONDecodable {
    
    let id: Int!
    let box: GameImageModel!
    let logo: GameImageModel!
    let name: String!
    let popularity: Int!
    
    required init?(json: JSON) {
        guard let id: Int = "_id" <~~ json,
            let box: GameImageModel = "box" <~~ json,
            let logo: GameImageModel = "logo" <~~ json,
            let name: String = "name" <~~ json,
            let popularity: Int = "popularity" <~~ json else {
                return nil
        }
        self.id = id
        self.box = box
        self.logo = logo
        self.name = name
        self.popularity = popularity
    }
    
}

class GameImageModel: JSONDecodable {
    
    let large: String?
    let medium: String?
    let small: String?
    let template: String?
    
    required init?(json: JSON) {
        self.large = "large" <~~ json
        self.medium = "medium" <~~ json
        self.small = "small" <~~ json
        self.template = "template" <~~ json
    }
    
}
