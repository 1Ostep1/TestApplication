//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Ramazan Iusupov on 26/7/23.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var creationTime: Date?

}
