//
//  CommentsVC.swift
//  JIRA-Swift
//
//  Created by Andriy Kramar on 6/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class CommentsVC: UITableViewController, AddCommentDelegate {

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
        viewModel.comments.removeAll()
        getComments()
    }
    
    override func rightBarButtonPressed() {        
        NavManager.presentAddComment(from: self, issue: viewModel.issue)
    }
    
    // MARK: Add comment delegate
    
    func commentAdded() {
        refresh()
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(tableView: tableView, section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.cell(tableView: tableView, indexPath: indexPath)
    }
}

//MARK: - CommentsCell

class CommentsCell: UITableViewCell {
    
    var comment: Comment?
    
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var tvBody: UITextView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var avatarImage: ImageViewCache!
    
    func customInit() {
        if let comment = comment {
            lbAuthor.text = comment.author?.displayName
            lbDate.text = comment.formattedCreated()
            tvBody.text = comment.body
            
            avatarImage.loadImage(url: comment.author?.avatarUrl, placeHolder: UIImage(named: "ic_no_avatar"))
            avatarImage.roundCorners()
        }
    }

}
