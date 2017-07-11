//
//  CommentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class CommentsVC: UITableViewController {

    var viewModel = CommentsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addRightBarButton(image: nil, title: "Add")
        navigationItem.title = viewModel.title
    }
    
    func getComments() {
        viewModel.getComments(fBlock: { [weak self] in
            
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.refreshControl?.endRefreshing()
            weakSelf.tableView.separatorStyle = .none

        }) { [weak self] (errString) in
            guard let weakSelf = self else { return }
            weakSelf.alert(title: "Error", message: errString)
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
        return viewModel.numberOfRows(tableView, section)
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
