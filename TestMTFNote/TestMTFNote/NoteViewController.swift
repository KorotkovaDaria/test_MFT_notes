//
//  ViewController.swift
//  TestMTFNote
//
//  Created by Daria on 29.01.2024.
//

import UIKit

class NoteViewController: UIViewController, EntryViewControllerDelegate {
    var storage: NoteStorageProtocol!
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var notes: [NoteItemProtocol] = [] {
        didSet {
            storage.save(notes: notes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = NoteStorage()
        
        view.backgroundColor = .brown
        
        view.addSubview(tableView)
        constraint()
        configTableView()
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
        loadNotes()
    }
    private func loadNotes() {
        notes = storage.load()
        if notes.isEmpty {
            let defaultNote = NoteItem(titleNote: "Конспект: Биология", textNote: "Наблюдение – метод, с помощью которого исследователь собирает информацию об объекте (можно визуально наблюдать за поведением животных, с помощью приборов за изменениями в природе). Выводы, сделанные наблюдателем, проверяются либо повторными наблюдениями, либо экспериментально.")
            notes.append(defaultNote)
            tableView.reloadData()
        }
    }
    
    func constraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "noteCell")
        tableView.allowsSelection = false
    }
    
    @objc func addNewNote() {
        let entryViewController = EntryViewController()
        entryViewController.delegate = self  // Set the delegate
        let navigationController = UINavigationController(rootViewController: entryViewController)
        present(navigationController, animated: true, completion: nil)
    }

    // Implement the delegate method
    func entryViewController(_ viewController: EntryViewController, didSaveNote note: NoteItem) {
        notes.append(note)
        tableView.reloadData()
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "noteCell")
        let noteItem = notes[indexPath.row]
        
        cell.textLabel?.text = noteItem.titleNote
        cell.detailTextLabel?.text = noteItem.textNote
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