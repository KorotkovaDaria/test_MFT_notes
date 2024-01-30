//
//  EntryViewController.swift
//  TestMTFNote
//
//  Created by Daria on 29.01.2024.
//

import UIKit

class EntryViewController: UIViewController {
    //MARK: - Properties
    weak var delegate: EntryViewControllerDelegate?
    //MARK: - Private properties
    private let entryView = EntryView()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(entryView)
        entryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            entryView.topAnchor.constraint(equalTo: view.topAnchor),
            entryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            entryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            entryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //Создание кнопки Save и Close
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeEntryController))
            saveButton.tintColor = UIColor(named: Resources.Colors.dark)
            closeButton.tintColor = UIColor(named: Resources.Colors.pink)
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.leftBarButtonItem = closeButton
    }
    // MARK: - objc function
    @objc func saveNote() {
        let title = entryView.titleTextField.text ?? ""
        let content = entryView.contentTextView.text ?? ""
        let newNote = NoteItem(titleNote: title, textNote: content)
        delegate?.entryViewController(self, didSaveNote: newNote)
        closeEntryController()
    }
    @objc func closeEntryController() {
        dismiss(animated: true, completion: nil)
    }
}
    // MARK: - Protocol
    protocol EntryViewControllerDelegate: AnyObject {
        func entryViewController(_ viewController: EntryViewController, didSaveNote note: NoteItem)
}
