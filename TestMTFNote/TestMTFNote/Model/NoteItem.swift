//
//  NoteItem.swift
//  TestMTFNote
//
//  Created by Daria on 29.01.2024.
//

import Foundation
protocol NoteItemProtocol {
    var titleNote: String { get set }
    var textNote: String { get set }
}

protocol NoteStorageProtocol {
    func load() -> [NoteItemProtocol]
    func save(notes: [NoteItemProtocol])
}

class NoteStorage: NoteStorageProtocol {
    private var storage = UserDefaults.standard
    private var storageKey = "notes"
    
    private enum NoteKey: String {
        case titleNote
        case textNote
        
    }
    func load() -> [NoteItemProtocol] {
        var resultNotes: [NoteItemProtocol] = []
        let notesFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for note in notesFromStorage {
            guard let title = note[NoteKey.titleNote.rawValue], let text = note[NoteKey.textNote.rawValue] else {
                continue
            }
            resultNotes.append(NoteItem(titleNote: title, textNote: text))
        }
        return resultNotes
    }
    
    func save(notes: [NoteItemProtocol]) {
        var arrForStorage: [[String:String]] = []
        notes.forEach { note in
            var newElementForStorage: Dictionary<String,String> = [:]
            newElementForStorage[NoteKey.titleNote.rawValue] = note.titleNote
            newElementForStorage[NoteKey.textNote.rawValue] = note.textNote
            arrForStorage.append(newElementForStorage)
        }
        storage.set(arrForStorage, forKey: storageKey)
    }
    
    
}

struct NoteItem: NoteItemProtocol {
    var titleNote: String
    var textNote: String
}
