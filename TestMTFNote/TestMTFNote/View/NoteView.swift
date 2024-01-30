//
//  NoteView.swift
//  TestMTFNote
//
//  Created by Daria on 30.01.2024.
//

import UIKit

class NoteView: UIView {
    //MARK: - Properties
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: Resources.Colors.beige)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        addSubview(tableView)
        setBackgroundColor()
        constraint()
    }
    // Настройка цвета заднего фона
    private func setBackgroundColor() {
        backgroundColor = UIColor(named: Resources.Colors.beige)
    }
    
    private func constraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
