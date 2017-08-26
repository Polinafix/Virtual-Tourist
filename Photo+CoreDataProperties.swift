//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 24/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var photoUrl: String?
    @NSManaged public var location: Pin?

}
