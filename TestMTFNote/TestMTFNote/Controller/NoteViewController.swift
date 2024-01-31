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
    private let cellIdentifier = "noteCell"
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = NoteStorage()
        setupView()
        setupTableView()
        setupNavBarItem()
        loadNotes()
    }
    //MARK: - Protocol function
    func entryViewController(_ viewController: EntryViewController, didSaveNote note: NoteItem) {
        notes.append(note)
        noteView.tableView.reloadData()
    }
    func entryViewController(_ viewController: EntryViewController, didUpdateNote note: NoteItem, at index: Int) {
        notes[index] = note
        noteView.tableView.reloadData()
    }
    
    //MARK: - Private function
    private func initializeEntryViewController() -> EntryViewController {
        let entryViewController = EntryViewController()
        entryViewController.delegate = self
        return entryViewController
    }
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
    private func setupTableView() {
        noteView.tableView.delegate = self
        noteView.tableView.dataSource = self
        noteView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        noteView.tableView.allowsSelection = false
        noteView.tableView.separatorStyle = .singleLine
        noteView.tableView.separatorColor = UIColor(named: Resources.Colors.beige)
    }
    private func setupNavBarItem() {
        navigationItem.title = "MY notes"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: Resources.Colors.pink)!,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        
        let addPluseButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        addPluseButton.tintColor = UIColor(named: Resources.Colors.pink)
        navigationItem.rightBarButtonItem = addPluseButton
    }
    private func loadNotes() {
        notes = storage.load()
        if notes.isEmpty {
            let defaultNote = NoteItem(titleNote: "Конспект: Биология", textNote: "Наблюдение – метод, с помощью которого исследователь собирает информацию об объекте (можно визуально наблюдать за поведением животных, с помощью приборов за изменениями в природе). Выводы, сделанные наблюдателем, проверяются либо повторными наблюдениями, либо экспериментально.")
            notes.append(defaultNote)
            noteView.tableView.reloadData()
        }
    }
    private func editNote(at indexPath: IndexPath) {
        let entryViewController = initializeEntryViewController()
        entryViewController.editingNoteIndex = indexPath.row
        entryViewController.existingNote = notes[indexPath.row] as? NoteItem
        
        let navigationController = UINavigationController(rootViewController: entryViewController)
        present(navigationController, animated: true, completion: nil)
    }
    // MARK: - objc function
    @objc func addNewNote() {
        let entryViewController = initializeEntryViewController()
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let noteItem = notes[indexPath.row]
        cell.backgroundColor = UIColor(named: Resources.Colors.beige2)
        cell.layer.cornerRadius = 15
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
        let actionEdit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.editNote(at: indexPath)
        }
        
        let actions = UISwipeActionsConfiguration(actions: [actionDelete,actionEdit])
        return actions
    }
}
