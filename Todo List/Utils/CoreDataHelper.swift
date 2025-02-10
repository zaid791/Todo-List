//
//  CoreDataHelper.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 10/02/25.
//

import UIKit
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func getAllItems() -> [TodoListItem] {
        do {
            return try context.fetch(TodoListItem.fetchRequest())
        } catch {
            print(error)
            return []
        }
    }
    
    func createItem(name: String) {
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        saveContext()
    }
    
    func delete(item: TodoListItem) {
        context.delete(item)
        saveContext()
    }
    
    func updateItem(item: TodoListItem, newName: String) {
        item.name = newName
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
