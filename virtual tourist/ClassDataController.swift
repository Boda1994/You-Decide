//
//  ClassDataController.swift
//  virtualtourist
//
//  Created by Abdualrahman on 6/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let sharedInstance = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "virtualtourist")
    
    var viewContext : NSManagedObjectContext {
       return persistentContainer.viewContext
    }
    
    func load() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
}
