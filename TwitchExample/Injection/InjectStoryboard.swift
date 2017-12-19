//
//  SwinjectStoryboard.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.register(APIClient.self) { _ in
            APIClient.init()
        }.inObjectScope(.container)
        
        defaultContainer.register(CoreDataManager.self) { _ in
            CoreDataManager.init()
        }.inObjectScope(.container)
        
        defaultContainer.storyboardInitCompleted(TopGamesViewController.self) { (r, c) in
            c.client = r.resolve(APIClient.self)
            c.coreDataManager = r.resolve(CoreDataManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(GameDetailViewController.self) { (r, c) in
            c.coreDataManager = r.resolve(CoreDataManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(PreviewGameDetailViewController.self) { (r, c) in
            c.coreDataManager = r.resolve(CoreDataManager.self)
        }
        
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { (r, c) in
            
        }
    }
    
}
