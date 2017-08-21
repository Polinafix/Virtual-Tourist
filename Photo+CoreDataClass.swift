//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 15/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    
    convenience init(photoData:Data, location:Pin, insertInto context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            
            self.init(entity: ent, insertInto: context)
            self.photoData = photoData as NSData?
            self.location = location
            
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
