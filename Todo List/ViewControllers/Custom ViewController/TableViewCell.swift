//
//  TableViewCell.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 05/02/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var btnCheckMark: UIButton!
    
    @IBOutlet weak var lblTask: UILabel!
    
    var isRadioSelected: Bool = false {
        didSet {
            btnCheckMark.isSelected = isRadioSelected
        }
    }
    
    var onRadioButtonTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnRadioClick(_ sender: UIButton) {
        onRadioButtonTap?()
    }
    
    func configure(with task: TodoListItem, isSelected: Bool) {
        lblTask.text = task.name
        isRadioSelected = isSelected
    }
}

