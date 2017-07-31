//
//  BoardsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/20/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BoardsVC: UITableViewController {

    var viewModel = BoardsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        AKActivityView.add(to: view)
        getBoards()
    }
    
    func getBoards() {
        viewModel.getBoards(sBlock: { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
            AKActivityView.remove(animated: true)
        }) { [weak self] (errString) in
            AKActivityView.remove(animated: true)
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func refresh() {
        viewModel.remove()
        getBoards()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueBoardsToDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBoardsToDetail" {
            let indexPath = sender as! IndexPath
            let vc = segue.destination as! BoardDetailsVC
            vc.viewModel = BoardDetailsViewModel(board: viewModel.board(index: indexPath.row))
        }
    }

}
