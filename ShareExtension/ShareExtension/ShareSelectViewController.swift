//
//  ShareSelectViewController.swift
//
//  Created by Robert Wong on 2/3/18.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit

protocol ShareSelectViewControllerDelegate: class {
    func selected(list: ListContainer)
}

class ShareSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var userList = [ListContainer]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self as UITableViewDataSource
        tableView.backgroundColor = .clear
        tableView.delegate = self as UITableViewDelegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.ListCell)
        return tableView
    }()
   
    weak var delegate: ShareSelectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        title = "Select List"
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ListCell, for: indexPath)
        cell.textLabel?.text = userList[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(list: userList[indexPath.row])
    }
}
    // ...
    private extension ShareSelectViewController {
        struct Identifiers {
            static let ListCell = "listCell"
        }
    }

