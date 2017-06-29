//
//  BoardsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/20/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class BoardsVC: UITableViewController {

    var boards: [Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        AKActivityView.add(to: view)
        getBoards()
    }
    
    func getBoards() {
        kMainModel.getBoards() { (response) in
            self.boards += response as! [Board]
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            AKActivityView.remove(animated: true)
        }
    }
    
    func refresh() {
        boards.removeAll()
        getBoards()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row < boards.count {
            let item = boards[indexPath.row]
            cell.textLabel?.text = item.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueBoardsToDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueBoardsToDetail" {
            let indexPath = sender as! IndexPath
            let item = boards[indexPath.row]
            let vc = segue.destination as! BoardDetailsVC
            vc.viewModel = BoardDetailsViewModel(board: item)
        }
    }

}
