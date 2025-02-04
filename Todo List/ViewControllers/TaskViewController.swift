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

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask() {
//        let count = UserDefaults().integer(forKey: "count")
//        let newCount = count - 1
//        
//        UserDefaults().set(newCount, forKey: "count")
//        UserDefaults().set(nil, forKey: "task_\(curentPosition)")
        navigationController?.popViewController(animated: true)
    }
}
