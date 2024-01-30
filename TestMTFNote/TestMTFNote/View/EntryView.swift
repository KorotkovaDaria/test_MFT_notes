//
//  EntryView.swift
//  TestMTFNote
//
//  Created by Daria on 30.01.2024.
//

import UIKit

class EntryView: UIView {
    //MARK: - Properties
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: Resources.Colors.beige2)
        textField.placeholder = "Заголовок заметки"
        textField.borderStyle = .roundedRect
        textField.textColor = UIColor(named: Resources.Colors.dark)
        return textField
    }()
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: Resources.Colors.beige2)
        textView.textColor = UIColor(named: Resources.Colors.dark)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        return textView
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private setup function
    private func configure() {
        setBackgroundColor()
        setupUI()
        
    }
    private func setBackgroundColor() {
        backgroundColor = UIColor(named: Resources.Colors.beige)
    }
    private func setupUI() {
        addSubview(titleTextField)
        addSubview(contentTextView)
        
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                        
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
