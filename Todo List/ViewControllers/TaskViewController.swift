//
//  TaskViewController.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 04/02/25.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: String?
    var taskIndex: Int?  // Store the index of the task
    var updateTasks: (() -> Void)?  // Closure to notify ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
        guard let index = taskIndex else { return }

        // Retrieve the count
        let count = UserDefaults.standard.integer(forKey: "count")

        // Shift remaining tasks
        for i in index..<count - 1 {
            if let nextTask = UserDefaults.standard.string(forKey: "task_\(i+2)") {
                UserDefaults.standard.set(nextTask, forKey: "task_\(i+1)")
            }
        }

        // Remove the last task key
        UserDefaults.standard.removeObject(forKey: "task_\(count)")
        UserDefaults.standard.set(count - 1, forKey: "count")

        // Notify ViewController to update the list
        updateTasks?()

        // Pop back to the main screen
        navigationController?.popViewController(animated: true)
    }
}

