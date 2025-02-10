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
    
    @IBOutlet weak var ivEmpty: UIImageView!
    
    var tasks: [TodoListItem] = []
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do List"
        getAllItems()
        setupTableView()
    }
    
    func getAllItems(){
        tasks = CoreDataHelper.shared.getAllItems()
        ivEmpty.isHidden = !tasks.isEmpty
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // Register the cell class
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        
        // Enable automatic height calculation
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.view.makeToast("Task Added Succesfully!")
                self.getAllItems()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapEdit(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        let title = tableView.isEditing ? "Done" : "Edit"
        sender.title = title
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = tasks[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Open", style: .default, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
            vc.title = "Task Details"
            vc.task = item
            vc.updateTasks = {
                DispatchQueue.main.async {
                    // Show Toast Message
                    self.view.makeToast("Deleted Successfully!")
                    self.getAllItems()  // Reload tasks after deletion
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit Your Item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {_ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else { return
                }
                CoreDataHelper.shared.updateItem(item: item, newName: newName)
                
                self.getAllItems()
            }))
            self.present(alert, animated: true)
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            CoreDataHelper.shared.delete(item: item)
            self.getAllItems()
        }))
        
        present(sheet, animated: true)
    }
    
}
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
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
            CoreDataHelper.shared.delete(item: tasks[indexPath.row])
            getAllItems()
            self.view.makeToast("Task Deleted")
        }
    }
    
}

extension UITableViewCell {
    /// Return Nib
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    /// Return Identifier
    public static var identifier: String {
        return String(describing: self)
    }
}
