//
//  DataController.swift
//  VirtualTourist
//
//  Created by Rahaf Naif on 16/11/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let dataController = DataController(modelName: "VirtualTourist")
    let persistentContainer : NSPersistentContainer
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
}
