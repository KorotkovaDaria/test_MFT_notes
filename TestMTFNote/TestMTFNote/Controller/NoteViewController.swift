//
//  ViewController.swift
//  TestMTFNote
//
//  Created by Daria on 29.01.2024.
//

import UIKit

class NoteViewController: UIViewController, EntryViewControllerDelegate {
    //MARK: - Properties
    var storage: NoteStorageProtocol!
    var notes: [NoteItemProtocol] = [] {
        didSet {
            storage.save(notes: notes)
        }
    }
    //MARK: - Private properties
    private var noteView = NoteView()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = NoteStorage()
        setupView()
        configTableView()
        loadNotes()
        
        //Создание кнопки добавления заметки
        let addPluseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        addPluseButton.tintColor = UIColor(named: Resources.Colors.pink)
        navigationItem.rightBarButtonItem = addPluseButton
    }
    //MARK: - Publish function
    func entryViewController(_ viewController: EntryViewController, didSaveNote note: NoteItem) {
        notes.append(note)
        noteView.tableView.reloadData()
    }
    
    //MARK: - Private function
    private func setupView() {
        view.addSubview(noteView)
        noteView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: view.topAnchor),
            noteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func configTableView() {
        noteView.tableView.delegate = self
        noteView.tableView.dataSource = self
        noteView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "noteCell")
        noteView.tableView.allowsSelection = false
    }
    private func loadNotes() {
        notes = storage.load()
        if notes.isEmpty {
            let defaultNote = NoteItem(titleNote: "Конспект: Биология", textNote: "Наблюдение – метод, с помощью которого исследователь собирает информацию об объекте (можно визуально наблюдать за поведением животных, с помощью приборов за изменениями в природе). Выводы, сделанные наблюдателем, проверяются либо повторными наблюдениями, либо экспериментально.")
            notes.append(defaultNote)
            noteView.tableView.reloadData()
        }
    }
    // MARK: - objc function
    @objc func addNewNote() {
        let entryViewController = EntryViewController()
        entryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: entryViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate extension
extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "noteCell")
        let noteItem = notes[indexPath.row]
        cell.backgroundColor = UIColor(named: Resources.Colors.beige2)
        cell.textLabel?.text = noteItem.titleNote
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        cell.textLabel?.textColor = UIColor(named: Resources.Colors.dark)
        cell.detailTextLabel?.text = noteItem.textNote
        cell.detailTextLabel?.textColor = UIColor(named: Resources.Colors.dark)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.notes.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}