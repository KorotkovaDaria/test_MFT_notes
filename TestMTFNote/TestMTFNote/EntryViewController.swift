//
//  EntryViewController.swift
//  TestMTFNote
//
//  Created by Daria on 29.01.2024.
//

import UIKit

class EntryViewController: UIViewController {
    weak var delegate: EntryViewControllerDelegate?
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Заголовок заметки"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Введите текст"
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray


        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        
        // Установите констрейнты для текстовых полей
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeEntryController))
    }
    
    @objc func saveNote() {
        
        let title = titleTextField.text ?? ""
            let content = contentTextView.text ?? ""

            let newNote = NoteItem(titleNote: title, textNote: content)
            delegate?.entryViewController(self, didSaveNote: newNote)
            closeEntryController()
    }
    
    @objc func closeEntryController() {
        // Добавьте здесь код для закрытия окна
        dismiss(animated: true, completion: nil)
    }
}

protocol EntryViewControllerDelegate: AnyObject {
    func entryViewController(_ viewController: EntryViewController, didSaveNote note: NoteItem)
}
