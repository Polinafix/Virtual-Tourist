//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 15/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    
    convenience init(_ latitude: Double,_ longitude: Double, context: NSManagedObjectContext?){
        
        if let pin = NSEntityDescription.entity(forEntityName: "Pin", in: context!){
        self.init(entity:pin, insertInto: context)
        self.latitude = latitude
        self.longitude = longitude
    }else{
        fatalError("Unable to find entity name!")
    }
    }
    
   
    

}
