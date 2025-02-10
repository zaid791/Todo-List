//
//  TodoListItem+CoreDataProperties.swift
//  
//
//  Created by Mohammed Zaid Shaikh on 10/02/25.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?

}
