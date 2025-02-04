//
//  ViewController.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 04/02/25.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [String] = []
    var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do List"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Setup defaults
        if UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        // Register the cell class
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        // Enable automatic height calculation
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44  // Provide a reasonable estimate
        
        
        //Get All Current Saved Tasks
        updateTasks()
    }
    
    func updateTasks(){
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if let task = UserDefaults.standard.value(forKey: "task_\(x+1)") as? String{
                tasks.append(task)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.view.makeToast("Task Added Succesfully!")
                self.updateTasks()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "Task Details"
        vc.task = tasks[indexPath.row]
        vc.taskIndex = indexPath.row
        vc.updateTasks = {
            DispatchQueue.main.async {
                // Show Toast Message
                self.view.makeToast("Deleted Successfully!")
                self.updateTasks()  // Reload tasks after deletion
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: tasks[indexPath.row], isSelected: indexPath.row == selectedIndex)
        
        cell.onRadioButtonTap = { [weak self] in
            self?.selectedIndex = indexPath.row
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from UserDefaults
            let count = UserDefaults.standard.integer(forKey: "count")
            
            for i in indexPath.row..<count - 1 {
                if let nextTask = UserDefaults.standard.string(forKey: "task_\(i+2)") {
                    UserDefaults.standard.set(nextTask, forKey: "task_\(i+1)")
                }
            }
            
            // Remove the last task key
            UserDefaults.standard.removeObject(forKey: "task_\(count)")
            UserDefaults.standard.set(count - 1, forKey: "count")
            
            // Remove from local tasks array
            tasks.remove(at: indexPath.row)
            
            // Update UI
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.view.makeToast("Task Deleted")
        }
    }
    
}

