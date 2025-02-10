//
//  EntryViewController.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 04/02/25.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTask)
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { 
        textField.resignFirstResponder()
        return true
    }
    
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        CoreDataHelper.shared.createItem(name: text)
        
        update?()
        
        navigationController?.popViewController(animated: true)
    }
}
