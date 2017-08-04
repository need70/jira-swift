//
//  CommentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class CommentsVC: UITableViewController {

    var viewModel = CommentsViewModel(issue: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
                
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addRightBarButton(image: nil, title: "Add")
        navigationItem.title = viewModel.title
    }
    
    func getComments() {
        viewModel.getComments(fBlock: { [weak self] in
            
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
//            self?.tableView.separatorStyle = .none

        }) { [weak self] (errString) in
            self?.alert(title: "Error", message: errString)
        }
    }
    
    func refresh() {
        viewModel.remove()
        getComments()
    }
    
    override func rightBarButtonPressed() {        
        Presenter.presentAddComment(from: self, issue: viewModel.issue)
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView, indexPath)
    }
}

extension CommentsVC: AddCommentDelegate {
    
    func commentAdded() {
        refresh()
    }
}
