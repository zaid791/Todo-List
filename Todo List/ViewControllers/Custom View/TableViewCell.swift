//
//  TableViewCell.swift
//  Todo List
//
//  Created by Mohammed Zaid Shaikh on 05/02/25.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "MyTableViewCell"
    
    private let radioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var isRadioSelected: Bool = false {
        didSet {
            radioButton.isSelected = isRadioSelected
        }
    }
    
    var onRadioButtonTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(myLabel)

        radioButton.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),

            myLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 16),
            myLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
    }
    
    @objc private func radioButtonTapped() {
        onRadioButtonTap?()
    }
    
    func configure(with text: String, isSelected: Bool) {
        myLabel.text = text
        isRadioSelected = isSelected
    }
}

