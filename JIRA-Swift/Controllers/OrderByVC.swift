//
//  OrderByVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/22/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class OrderByVC: UITableViewController, UISearchBarDelegate {

    var viewModel = OrderByViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sort By"
        addLeftBarButton(image: nil, title: "Cancel")
        addRightBarButton(image: nil, title: "Apply")
        
        AKActivityView.add(to: view)
        tableView.separatorStyle = .none
        getOrderBy()
    }
    
    func getOrderBy() {
        viewModel.getOrderBy(fBlock: { [weak self] (items) in
            self?.tableView.separatorStyle = .singleLine
            self?.tableView.reloadData()
            AKActivityView.remove(animated: true)
            
        }) {[weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    override func rightBarButtonPressed() {
        dismiss(animated: true) {
            self.viewModel.handleSelectedField()
        }
    }
    
    override func leftBarButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView: tableView, section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.setSelectedField(index: indexPath.row)
        tableView.reloadData()
    }

    //MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.handleSearchBar(text: searchText)
        self.tableView.reloadData()
    }
}
