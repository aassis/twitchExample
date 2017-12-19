//
//  CoreDataGame+CoreDataProperties.swift
//  
//
//  Created by André Assis on 15/12/17.
//
//

import Foundation
import CoreData


extension CoreDataGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataGame> {
        return NSFetchRequest<CoreDataGame>(entityName: "FavoriteGame")
    }

    @NSManaged public var gameId: Int64

}
