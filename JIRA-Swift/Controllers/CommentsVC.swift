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
        viewModel.getComments(completition: { [weak self] (result) in
            
            switch result {
                
            case .success(_):
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()

            case .failed(let err):
                self?.refreshControl?.endRefreshing()
                self?.alert(title: "Error", message: err)

            }
        })
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
