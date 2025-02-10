//
//  TaskViewController.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 04/02/25.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: TodoListItem?
    var updateTasks: (() -> Void)?  // Closure to notify ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task?.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
        CoreDataHelper.shared.delete(item: task!)

        // Notify ViewController to update the list
        updateTasks?()

        // Pop back to the main screen
        navigationController?.popViewController(animated: true)
    }
}

